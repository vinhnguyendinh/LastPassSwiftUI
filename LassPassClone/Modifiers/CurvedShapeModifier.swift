//
//  CurvedShapeModifier.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct CurvedShapeModifier: ViewModifier {
    var shouldClip = false
    func body(content: Content) -> some View {
        
        if shouldClip {
            return AnyView(content.clipShape(CurvedShape()))
        } else {
            return AnyView(content)
        }
    }
}

extension View {
    func clip(shouldCurve: Bool) -> some View {
        self.modifier(CurvedShapeModifier(shouldClip: shouldCurve))
    }
}
