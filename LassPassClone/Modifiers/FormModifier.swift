//
//  FormModifier.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct FormModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.padding()
            .background(Color.background)
            .cornerRadius(10)
            .padding()
            .neumorphic()
    }
}
