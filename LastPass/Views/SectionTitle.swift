//
//  SectionTitle.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct SectionTitle: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .frame(maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            .padding(.leading, 40)
            .background(Color.background)    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(title: "Last pass")
    }
}
