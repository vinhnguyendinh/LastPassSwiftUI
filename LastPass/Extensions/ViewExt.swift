//
//  ViewExt.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/11.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

extension View {
    func innerShadow(radius: CGFloat, colors: (dark: Color, light:Color)) -> some View {
        self.overlay(
            Circle()
                .stroke(colors.dark, lineWidth: 4)
                .blur(radius: radius)
                .offset(x: radius, y: radius)
                .mask(Circle().fill(LinearGradient.init(colors.dark, Color.clear)))
            
        ).overlay(
            Circle()
                .stroke(colors.light, lineWidth: 8)
                .blur(radius: radius)
                .offset(x: -radius, y: -radius)
                .mask(Circle().fill(LinearGradient(Color.clear, colors.dark)))
        )
    }
}
