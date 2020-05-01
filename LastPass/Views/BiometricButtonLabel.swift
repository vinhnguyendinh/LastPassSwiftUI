//
//  BiometricButtonLabel.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct BiometricButtonLabel: View {
    var icon = "touchID"
    var text = "Use touch ID"
    
    var body: some View {
        VStack {
            Image(systemName: self.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(self.text)
        }.foregroundColor(Color.accent)
    }
}


struct BiometricButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        BiometricButtonLabel()
    }
}
