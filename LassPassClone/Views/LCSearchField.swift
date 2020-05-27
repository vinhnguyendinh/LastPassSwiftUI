//
//  LCSearchField.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct LCSearchField: View {
    @Binding var value: String
    var onEditingChanged: ((Bool)-> Void) = {_ in }
    var onCommit: (() -> ()) = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
                .padding(.leading)

            TextField("Search ...", text: self.$value, onEditingChanged: self.onEditingChanged, onCommit: {
                self.onCommit()
            }).padding(.vertical, 10)
        }.foregroundColor(Color.gray)
        .background(Color.background)
        .cornerRadius(13)
        .padding()
        .frame(height: 45)
        .shadow(color: Color.darkShadow, radius: 5, x: 0, y: 5)  
    }
}

struct LCSearchField_Previews: PreviewProvider {
    static var previews: some View {
        LCSearchField(value: .constant(""))
    }
}
