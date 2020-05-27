//
//  HapticFeedback.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/04/30.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct HapticFeedback {
    public static func generate(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}
