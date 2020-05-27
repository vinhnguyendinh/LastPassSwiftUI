//
//  PasswordGeneratorView.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/11.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct PasswordGeneratorView: View {
    @Binding var generatedPassword: String
    
    @ObservedObject private var passwordService = PasswordGeneratorService()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Generate password").font(.title).bold()
            
            Group {
                SharedTextfield(value: self.$passwordService.password, header: "Generated Password", placeholder: "Your new password", errorMessage: "", showUnderline: false, onEditingChanged: { flag in
                }).padding()
            }.background(Color.background)
                .cornerRadius(10)
                .neumorphic()
            
            VStack(spacing: 10){
                Toggle(isOn: self.$passwordService.options.lowercase) {
                    Text("Lowercase")
                }.toggleStyle(CustomToggleStyle())
                
                Toggle(isOn: self.$passwordService.options.uppercase) {
                    Text("Uppercase")
                }.toggleStyle(CustomToggleStyle())
                
                Toggle(isOn: self.$passwordService.options.specialCharacters) {
                    Text("Special Characters")
                }.toggleStyle(CustomToggleStyle())
                
                Toggle(isOn: self.$passwordService.options.digits) {
                    Text("Digits")
                }.toggleStyle(CustomToggleStyle())
                
                HStack {
                    Slider(value: self.$passwordService.options.length, in: 1...30, step: 1)
                        .accentColor(Color.accent)
                    
                    Text("\(Int(self.passwordService.options.length))")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                    
                }
                
            }.padding()
                .background(Color.background)
                .cornerRadius(10)
                .neumorphic()
            
        }.padding(.horizontal)
            .frame(maxHeight: .infinity)
            .background(Color.background)
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                self.generatedPassword = self.passwordService.password
        }
    }
}

struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView(generatedPassword: .constant(""))
    }
}
