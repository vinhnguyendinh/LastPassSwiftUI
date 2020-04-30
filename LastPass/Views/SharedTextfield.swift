//
//  SharedTextfield.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct SharedTextfield: View {
    @Binding var value: String
    var header = "Username"
    var placeholder = "Your username or email"
    var trailingIconName = ""
    var errorMessage = ""
    var showUnderline = true
    var onEditingChanged: ((Bool) -> ()) = { _ in }
    var onCommit: (() -> ()) = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(header.uppercased()).font(.footnote).foregroundColor(Color.gray)
            
            self.createTextFieldAndIconView()
            
            if showUnderline {
                Rectangle().frame(height: 1).foregroundColor(Color.gray)
            }
            
            self.createErrorMesgView()
        }.background(Color.background)
    }
    
    private func createTextFieldAndIconView() -> some View {
        return HStack {
            TextField(placeholder, text: self.$value, onEditingChanged: { flag in
                self.onEditingChanged(flag)
            }, onCommit: {
                self.onCommit()
            }).padding(.vertical, 15)
            
            if !self.trailingIconName.isEmpty {
                Image(systemName: self.trailingIconName )
                    .foregroundColor(Color.gray)
            }
        }.frame(height: 45)
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
}

struct SharedTextfield_Previews: PreviewProvider {
    static var previews: some View {
        SharedTextfield(value: .constant(""))
    }
}
