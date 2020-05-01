//
//  AccountCreationView.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct AccountCreationView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    
    @Binding var showLogin: Bool
    @State private var formOffset: CGFloat = 0    
    @State private var showAlert = false
    
    var body: some View {
        SubscriptionView(content: createContent(), publisher: NotificationCenter.keyboardPublisher) { frame in
            withAnimation {
                self.formOffset = frame.height > 0 ? -200 : 0
            }
        }
    }
    
    fileprivate func goToLoginButton() -> some View {
        return Button(action: {
            self.authManager.email = ""
            self.authManager.password = ""
            self.authManager.confirmedPassword = ""
            
            withAnimation(.spring() ) {
                self.showLogin.toggle()
            }
        }) {
            HStack {
                Text("Login")
                    .accentColor(Color.darkerAccent)
                Image(systemName: "arrow.right.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(Color.darkerAccent)
                
            }
        }
    }
    
    fileprivate func createContent() -> some View {
        VStack {
            self.createIconView()
            
            VStack(spacing: 10) {
                Text("Create Account")
                    .font(.title)
                    .bold()
                
                /// Form sign up
                self.createFormSignUp()
                
                /// Sign up button
                self.createSignUpButton()
                
            }.modifier(FormModifier()).offset(y: self.formOffset)
            
            goToLoginButton()
        }
    }
    
    private func createIconView() -> some View {
        return Image("singlePass-dynamic")
            .resizable()
            .aspectRatio(contentMode: .fit) 
            .frame(height: 30)
            .padding(.bottom)
    }
    
    private func createFormSignUp() -> some View {
        return VStack(spacing: 30) {
            SharedTextfield(value: self.$authManager.email,header: "Email", placeholder: "Your primary email",errorMessage: authManager.emailValidation.message)
            PasswordField(value: self.$authManager.password,header: "Password",  placeholder: "Make sure it's string",errorMessage: authManager.passwordValidation.message, isSecure: true)
            PasswordField(value: self.$authManager.confirmedPassword,header: "Confirm Password",  placeholder: "Must match the password", errorMessage: authManager.confirmedPasswordValidation.message, isSecure: true)
            
            Text(self.authManager.similarityValidation.message).foregroundColor(Color.red)
        }
    }
    
    private func createSignUpButton() -> some View {
        return LCButton(text: "Sign up", backgroundColor: self.authManager.canSignup ? Color.accent : Color.gray ) {
            self.showAlert = !self.authManager.createAccount()
        }.disabled(!self.authManager.canSignup)
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text("Error"), 
                      message: Text("Oops! Seems like there's already an account associated with this device. You need to login instead."), 
                      dismissButton: .default(Text("Ok")))
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(showLogin: .constant(false))
    }
}
