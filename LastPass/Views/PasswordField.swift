//
//  PasswordField.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct PasswordField: View {
    @Binding var value: String
    var header = "Username"
    var placeholder = "Your password"
    var errorMessage = ""
    var trailingIconName = ""
    var showUnderline = true
    var onEditingChanged: ((Bool)->()) = {_ in }
    var onCommit: (()->()) = {}
    @State var isSecure: Bool = true
    let pasteboard = UIPasteboard.general
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(header.uppercased()).font(.footnote).foregroundColor(Color.gray)
            
            HStack {
                self.createTextfield()
                self.createIconImageView()
            }.frame(height: 45)
            
            Rectangle().frame(height: 1).foregroundColor(Color.gray)
            
            self.createErrorMesgView()
            
        }.background(Color.background)
    }
    
    private func createErrorMesgView() -> some View {
        if !errorMessage.isEmpty {
            return AnyView(
                Text(errorMessage)
                    .lineLimit(nil)
                    .font(.footnote)
                    .foregroundColor(Color.red)
                    .transition(AnyTransition.opacity.animation(.easeIn))
            )
        }
        
        return AnyView(EmptyView())
    }
    
    private func createTextfield() -> some View {
        return ZStack {
            SecureField(placeholder, text: self.$value, onCommit: {
                self.onEditingChanged(false)
            }).padding(.vertical, 15).opacity(isSecure ? 1 : 0)
            
            TextField(placeholder, text: self.$value, onEditingChanged: { flag in
                self.onEditingChanged(flag)
            }).padding(.vertical, 15).opacity(isSecure ? 0 : 1)
        }
    }
    
    private func createIconImageView() -> some View {
        return HStack {
            if isSecure {
                Image(systemName: "eye.slash")
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        withAnimation {
                            self.isSecure.toggle()
                        }
                }
            } else {
                Image(systemName: "eye")
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        withAnimation {
                            self.isSecure.toggle()
                        }
                }
            }
            
            if !isSecure {
                Image(systemName: self.trailingIconName)
                    .foregroundColor(Color.gray)
                    .transition(.opacity)
                    .onTapGesture {
                        self.pasteboard.string = self.value
                }
            }
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(value: .constant(""))
    }
}
