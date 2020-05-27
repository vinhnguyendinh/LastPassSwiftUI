//
//  AuthenticationManager.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI
import Combine
import KeychainSwift
import CryptoKit
import LocalAuthentication

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    // MARK: - Properties
    enum BiometricResult {
        case success
        case failure
        case none
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    /// Email, password, confirmed password
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmedPassword: String = ""
    
    /// Check login and signup
    @Published var canLogin: Bool = false
    @Published var canSignup: Bool = false
    
    /// Validation email and password
    @Published var emailValidation = FormValidation()
    @Published var passwordValidation = FormValidation()
    @Published var confirmedPasswordValidation = FormValidation()
    @Published var similarityValidation = FormValidation()
    
    /// Login with keychain and biometrics
    @Published var biometryType: LABiometryType = .none
    @Published var isLoggedIn: Bool = false
    @Published var userAccount = User()
    @Published var biometricResult: BiometricResult = .none
    
    /// Reset password
    @Published var resetPassword: String = ""
    @Published var resetPasswordValidation = FormValidation()
    
    private var keychain = KeychainSwift()
    private var userDefaults = UserDefaults.standard
    private var laContext = LAContext()
    private var myLocalizedReasonString: String = "Face ID authentication"
    
    /// Email, password, confirmed password, similarity password publisher
    private var emailPublisher: AnyPublisher<FormValidation, Never> {
        self.$email.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                if email.isEmpty {
                    return FormValidation(success: false, message: "")
                }
                
                if !Config.emailPredicate.evaluate(with: email) {
                    return FormValidation(success: false, message: "Invalid email address")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var passwordPublisher: AnyPublisher<FormValidation, Never> {
        self.$password.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                if password.isEmpty {
                    return FormValidation(success: false, message: "")
                }
                
                if password.count < Config.recommendedLength {
                    return FormValidation(success: false, message: "The password length must be greater than \(Config.recommendedLength) ")
                }
                
                if !Config.passwordPredicate.evaluate(with: password) {
                    return FormValidation(success: false, message: "The password is must contain numbers, uppercase and special characters")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var confirmPasswordPublisher: AnyPublisher<FormValidation, Never> {
        self.$confirmedPassword.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                
                if password.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                
                if password.count < Config.recommendedLength {
                    return FormValidation(success: false, message: "The password length must be greater than \(Config.recommendedLength) ")
                }
                
                if !Config.passwordPredicate.evaluate(with: password) {
                    return FormValidation(success: false, message: "The password is must contain numbers, uppercase and special characters")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var similarityPublisher: AnyPublisher<FormValidation, Never> {
        Publishers.CombineLatest($password, $confirmedPassword)
            .map { password, confirmedPassword in
                
                if password.isEmpty || confirmedPassword.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                
                if password != confirmedPassword{
                    return FormValidation(success: false, message: "Passwords do not match!")
                }
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    /// Biometrics publisher
    private lazy var biometryPublisher: Future<BiometricResult, Never> = {
        Future<BiometricResult, Never> { [weak self] promise in
            guard let `self` = self else { return }
            
            let localizedReasonString = "We want to use biometrics to login"
            var authError: NSError?
            self.laContext.localizedFallbackTitle = "Please use your Passcode"
            if self.canAuthenticate(error: &authError) {
                self.laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.myLocalizedReasonString) { success, evaluateError in
                    return success ? promise(.success(BiometricResult.success)) : promise(.success(BiometricResult.failure))
                }
            } else {
                print(authError ?? "")
                return promise(.success(BiometricResult.failure))
            }
        }
    }()
    
    /// Reset password publisher
    private var resetPasswordPublisher: AnyPublisher<FormValidation, Never> {
        self.$resetPassword.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                
                if password.isEmpty {
                    return FormValidation(success: false, message: "")
                }
                
                if password.count < Config.recommendedLength {
                    return FormValidation(success: false, message: "The password length must be greater than \(Config.recommendedLength) ")
                }
                
                if !Config.passwordPredicate.evaluate(with: password) {
                    return FormValidation(success: false, message: "The password is must contain numbers, uppercase and special characters")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Initial
    private init() {
        self.setupInit()
    }
    
    // MARK: - Configs
    private func setupInit() {
        emailPublisher
            .assign(to: \.emailValidation, on: self)
            .store(in: &self.cancellableSet)
        
        passwordPublisher
            .assign(to: \.passwordValidation, on: self)
            .store(in: &self.cancellableSet)
        
        confirmPasswordPublisher
            .assign(to: \.confirmedPasswordValidation, on: self)
            .store(in: &self.cancellableSet)
        
        similarityPublisher
            .assign(to: \.similarityValidation, on: self)
            .store(in: &self.cancellableSet)
        
        Publishers.CombineLatest(emailPublisher, passwordPublisher)
            .map { emailValidation, passwordValidation  in
                emailValidation.success && passwordValidation.success
        }.assign(to: \.canLogin, on: self)
            .store(in: &self.cancellableSet)
        
        Publishers.CombineLatest4(emailPublisher, passwordPublisher, confirmPasswordPublisher, similarityPublisher)
            .map { emailValidation, passwordValidation, confirmedPasswordValidation, similarityValidation  in
                emailValidation.success && passwordValidation.success && confirmedPasswordValidation.success && similarityValidation.success
        }.assign(to: \.canSignup, on: self)
            .store(in: &self.cancellableSet)
        
        self.getBiometryType()
        
        resetPasswordPublisher
            .assign(to: \.resetPasswordValidation, on: self)
            .store(in: &self.cancellableSet)
    }
    
    // MARK: - Handler
    func hasAccount() -> Bool {
        return keychain.get(AuthKeys.email) != nil
    }
    
    func createAccount() -> Bool {
        guard !hasAccount() else { return false }
        let hashedPassword = hashPassword(password)
        let emailResult = keychain.set(email.lowercased(), forKey: AuthKeys.email, withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
        let passwordResult = keychain.set(hashedPassword, forKey: AuthKeys.password, withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
        if emailResult && passwordResult {
            login()
            return true
        }
        return false
    }
    
    func login() {
        userDefaults.set(true, forKey: AuthKeys.isLoggedIn)
        self.isLoggedIn = true
    }
    
    private func hashPassword(_ password: String, reset: Bool = false) -> String {
        var salt = ""
        
        if let savedSalt = keychain.get(AuthKeys.salt), !reset {
            salt = savedSalt
        } else {
            let key = SymmetricKey(size: .bits256)
            salt = key.withUnsafeBytes({ Data(Array($0)).base64EncodedString() })
            keychain.set(salt, forKey: AuthKeys.salt)
        }
        
        guard let data = "\(password)\(salt)".data(using: .utf8) else { return "" }
        let digest = SHA256.hash(data: data)
        return digest.map{String(format: "%02hhx", $0)}.joined()
    }
    
    func authenticate(username: String, password: String) -> Bool {
        if !hasAccount() {
            return false
        }
        
        if let savedEmail = keychain.get(AuthKeys.email), let savedPassword = keychain.get(AuthKeys.password){
            let hashedPassword = hashPassword(password)
            if savedEmail == username.lowercased() && hashedPassword == savedPassword {
                login()
                return true
            }
        }
        return false
    }
    
    func logout() {
        userDefaults.set(false, forKey: AuthKeys.isLoggedIn)
        self.isLoggedIn = false
    }
    
    func deleteAccount()  {
        keychain.delete(AuthKeys.email)
        keychain.delete(AuthKeys.password)
        keychain.delete(AuthKeys.salt)
        logout()
    }
    
    func canAuthenticate(error: NSErrorPointer) -> Bool {
        return self.laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: error)
    }
    
    func loginWithBiometric()  {
        guard hasAccount() else { return }
        
        biometryPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                switch result{
                case .success:
                    self.isLoggedIn = true
                case .failure:
                    self.isLoggedIn = false
                    print("Error authenticating with biometrics")
                case .none:
                    break
                }
            })
            .store(in: &self.cancellableSet)
    }
    
    func authenticateWithBiometric()  {
        guard hasAccount() else { return }
        
        biometryPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.biometricResult, on: self)
            .store(in: &self.cancellableSet)
    }
    
    func getBiometryType() {
        var authError: NSError?
        if canAuthenticate(error: &authError) {
            self.biometryType = laContext.biometryType
        }
    }
    
    func saveResetPassword() -> Bool {
        let hashedPassword = hashPassword(resetPassword, reset: true)
        let passwordResult = keychain.set(hashedPassword, forKey: AuthKeys.password, withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
        return passwordResult
    }
}
