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
    
    fileprivate func goToLoginButton() -> some View {
        return Button(action: {
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
    
    fileprivate func createContent() -> some View{
        VStack {
            Image("singlePass-dynamic").resizable().aspectRatio(contentMode: .fit) .frame(height: 30)
                .padding(.bottom)
            VStack(spacing: 10) {
                Text("Create Account").font(.title).bold()
                VStack(spacing: 30) {
                    SharedTextfield(value: self.$authManager.email,header: "Email", placeholder: "Your primary email",errorMessage: authManager.emailValidation.message)
                    PasswordField(value: self.$authManager.password,header: "Password",  placeholder: "Make sure it's string",errorMessage: authManager.passwordValidation.message, isSecure: true)
                    PasswordField(value: self.$authManager.confirmedPassword,header: "Confirm Password",  placeholder: "Must match the password", errorMessage: authManager.confirmedPasswordValidation.message, isSecure: true)
                    
                    Text(self.authManager.similarityValidation.message).foregroundColor(Color.red)
                }
                LCButton(text: "Sign up", backgroundColor: self.authManager.canSignup ? Color.accent : Color.gray ) {
                    
                }.disabled(!self.authManager.canSignup)
                
            }.modifier(FormModifier()).offset(y: self.formOffset)
            
            goToLoginButton()
        }
    }
    
    var body: some View {
        
        SubscriptionView(content: createContent(), publisher: NotificationCenter.keyboardPublisher) { frame in
            withAnimation {
                self.formOffset = frame.height > 0 ? -200 : 0
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(showLogin: .constant(false))
    }
}
