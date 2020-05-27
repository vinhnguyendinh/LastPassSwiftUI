//
//  LinearGradientExt.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/11.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
