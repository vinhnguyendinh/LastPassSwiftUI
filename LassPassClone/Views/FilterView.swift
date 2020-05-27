//
//  FilterView.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    var filter: Filter
    @Binding var isSelected: Bool
    var onSelect: ((Filter)->()) = {_ in }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Text(filter.rawValue)
                .layoutPriority(1)
                .foregroundColor(isSelected ? Color.text : Color.gray)
                .padding(5)
            
            if isSelected {
                Rectangle()
                    .frame(width: 50, height: 3)
                    .foregroundColor(Color.accent)
                    .cornerRadius(2)
                    .transition(.scale)
            }
        }.padding().onTapGesture {
            self.onSelect(self.filter)
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filter: .AllItems, isSelected: .constant(true))
    }
}
