//
//  LoginView.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    
    @Binding var showCreateAccount: Bool
    @State private var formOffset: CGFloat = 0    
    @State private var showAlert = false
    @State private var showResetPasswordPopup = false
    
    var body: some View {
        ZStack {
            SubscriptionView(content: createContent(), publisher: NotificationCenter.keyboardPublisher) { frame in
                withAnimation {
                    self.formOffset = frame.height > 0 ? -150 : 0
                }
            }
            
            VStack {
                if showResetPasswordPopup {
                    showPopups()
                        .offset(y: self.formOffset)
                        .transition(.scale)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.6))
                .opacity(showResetPasswordPopup ? 1 : 0)
                .animation(.spring())
            
            
        }  
    }
    
    fileprivate func createContent() -> some View {
        VStack {
            Image("singlePass-dynamic").resizable().aspectRatio(contentMode: .fit) .frame(height: 30)
                .padding(.bottom)
            
            VStack(spacing: 30) {
                Text("Login")
                    .font(.title)
                    .bold()
                
                self.createFormLogin()
            }.modifier(FormModifier())
                .offset(y: self.formOffset)
            
            createAccountButton()
            
            if self.authManager.hasAccount() {
                Text("OR").bold()
                createResetPasswordButton()
            }        
        }
    }
    
    fileprivate func createFormLogin() -> some View {
        VStack(spacing: 30) {
            SharedTextfield(value: self.$authManager.email, header: "Email", placeholder: "Your email", errorMessage: self.authManager.emailValidation.message)
            PasswordField(value: self.$authManager.password, header: "Master Password", placeholder: "Make sure the password is strong", errorMessage: self.authManager.passwordValidation.message, isSecure: true)
            
            self.createLoginButton()
            
            if self.authManager.hasAccount() {
                self.createBiometricButton {
                    self.authManager.loginWithBiometric()
                }
            }
        }
    }
    
    fileprivate func createLoginButton() -> some View {
        return LCButton(text: "Login", backgroundColor: Color.accent ) {
            self.showAlert = !self.authManager.authenticate(username: self.authManager.email, 
                                                            password: self.authManager.password)
        }.disabled(!self.authManager.canLogin)
            .alert(isPresented: self.$showAlert) {
                if self.authManager.hasAccount() {
                    return Alert(title: Text("Error"), message: Text("Oops!The credentials you've provided are not correct, try again."), dismissButton: Alert.Button.default(Text("Ok")) )
                }
                
                return Alert(title: Text("Error"), message: Text("Oops! You don't have an account yet, sign uo instead."), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
    
    fileprivate func createAccountButton() -> some View {
        return Button(action: {
            self.authManager.email = ""
            self.authManager.password = ""
            
            withAnimation(.spring()) {
                self.showCreateAccount.toggle()
            }
        }) {
            HStack {
                Image(systemName: "arrow.left.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(Color.darkerAccent)
                Text("Create account")
                    .accentColor(Color.darkerAccent)
            }
        }
    }
    
    fileprivate func createResetPasswordButton() -> some View {
        return Button(action: {
            withAnimation(.spring()) {
                self.showResetPasswordPopup.toggle()
            }
        }) {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(Color.darkerAccent)
                Text("Reset Password")
                    .accentColor(Color.darkerAccent)
            }
        }
    }
    
    private func createBiometricButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            if self.authManager.biometryType == LABiometryType.faceID{
                BiometricButtonLabel(icon: "faceid", text: "Use face ID")
            }
            
            if self.authManager.biometryType == LABiometryType.touchID{
                BiometricButtonLabel()
            }
        }
    }
    
    private func biometricPopupView() -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                Text(self.authManager.biometricResult == .failure ? "Failed" : "Authentication required")
                    .bold()
                    .foregroundColor(self.authManager.biometricResult == .failure ? .red : .accent)
                createBiometricButton {
                    self.authManager.authenticateWithBiometric()
                }
            }.frame(width: 250, height: 200)
                .background(Color.background)
                .cornerRadius(20)
            
            Button(action: {
                self.showResetPasswordPopup.toggle()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .padding()
                    .foregroundColor(.gray)
                    .opacity(0.6)
            }   
        }
    }
    
    private func resetPassordPopupView() -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 40) {
                Text("Set your new password")
                    .bold()
                    .foregroundColor(.accent)
                PasswordField(value: self.$authManager.resetPassword, header: "New Password", placeholder: "New password goes here...", errorMessage: authManager.resetPasswordValidation.message , isSecure: true)
                
                LCButton(text: "Save", backgroundColor: self.authManager.resetPasswordValidation.success ? Color.accent : Color.gray) {
                    self.showResetPasswordPopup = !self.authManager.saveResetPassword()
                }.disabled(!self.authManager.resetPasswordValidation.success)
            }.padding(.horizontal).frame(maxWidth: .infinity, maxHeight: 280)
                .background(Color.background)
                .cornerRadius(20)
            
            Button(action: {
                self.showResetPasswordPopup.toggle()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .padding()
                    .foregroundColor(.gray)
            }
            
        }
    }
    
    func showPopups() -> some View {
        switch self.authManager.biometricResult {
        case .success:
            return AnyView(resetPassordPopupView().padding())
        default:
            return AnyView(biometricPopupView())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showCreateAccount: .constant(true))
    }
}
