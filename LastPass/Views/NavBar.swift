//
//  NavBar.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct NavBar: View {
    @Binding var showMenu: Bool
    @State private var searchTerm = ""

    var title: String = "Vault"
    var showSearchField = true

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                Spacer()
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding(.trailing)
                
            }.padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .frame(height: showSearchField ? 140 : 90, 
                       alignment: showSearchField ? .center : .bottom)
                .background(Color.accent)
                .clip(shouldCurve: showSearchField)
            
            if showSearchField {
                LCSearchField(value: self.$searchTerm)
                    .padding()
                    .offset(y: 15)
            }
        }    
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(showMenu: .constant(true))
    }
}
