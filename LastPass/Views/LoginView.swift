//
//  LoginView.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthenticationManager

    @Binding var showCreateAccount: Bool
    @State private var formOffset: CGFloat = 0    
    
    var body: some View {
        SubscriptionView(content: createContent(), publisher: NotificationCenter.keyboardPublisher) { frame in
            withAnimation {
                self.formOffset = frame.height > 0 ? -200 : 0
            }
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
                
                VStack(spacing: 30) {
                    SharedTextfield(value: self.$authManager.email, header: "Email", placeholder: "Your email", errorMessage: self.authManager.emailValidation.message)
                    PasswordField(value: self.$authManager.password, header: "Master Password", placeholder: "Make sure the password is strong", errorMessage: self.authManager.passwordValidation.message, isSecure: true)
                    
                    LCButton(text: "Login", backgroundColor: Color.accent ) {
                        
                    }.disabled(!self.authManager.canLogin)
                    
                    Button(action: {
                        
                    }) {
                        VStack {
                            Image(systemName: "faceid")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.accent)
                            Text("Use face ID").foregroundColor(.accent)
                        }
                    }
                }
                
                
            }.modifier(FormModifier()).offset(y: self.formOffset)
            createAccountButton()
        }
    }
    
    fileprivate func createAccountButton() -> some View {
        return Button(action: {
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showCreateAccount: .constant(true))
    }
}
