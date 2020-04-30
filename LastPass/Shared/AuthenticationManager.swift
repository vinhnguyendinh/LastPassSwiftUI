//
//  AuthenticationManager.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

class AuthenticationManager: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    
    @Published var canLogin = false
    @Published var canSignup = false
    
    @Published var emailValidation = FormValidation()
    @Published var passwordValidation = FormValidation()
    @Published var confirmedPasswordValidation = FormValidation()
    @Published var similarityValidation = FormValidation()
    
    private var emailPublisher: AnyPublisher<FormValidation, Never> {
        self.$email.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                // To be created outside
                let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
                
                if email.isEmpty {
                    return FormValidation(success: false, message: "")
                }
                
                
                if !predicate.evaluate(with: email) {
                    return FormValidation(success: false, message: "Invalid email address")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var passwordPublisher: AnyPublisher<FormValidation, Never> {
        self.$password.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                
                if password.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                
                if password.count < PasswordConfig.recommendedLength {
                    return FormValidation(success: false, message: "The password length must be greater than \(PasswordConfig.recommendedLength) ")
                }
                
                let regEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
                let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
                
                if !predicate.evaluate(with: password) {
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
                
                if password.count < PasswordConfig.recommendedLength {
                    return FormValidation(success: false, message: "The password length must be greater than \(PasswordConfig.recommendedLength) ")
                }
                
                let regEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
                let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
                
                if !predicate.evaluate(with: password) {
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
    
    init() {
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
    }
}
