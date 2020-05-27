//
//  CustomToggleStyle.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/11.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {   
    var onColor: Color = .background
    var offColor: Color = .darkerAccent
    var size: CGFloat = 40
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                configuration.label
                Spacer()
                Button(action: {
                    configuration.isOn.toggle()
                }) {
                    if configuration.isOn {
                        ZStack {
                            Circle()
                                .fill(Color.background)
                                .frame(width: size, height: size)
                                .innerShadow(radius: 1, colors: (Color.darkShadow, Color.lightShadow))
                            
                            Image(systemName: "power")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.accent)
                        }    
                    } else {
                        ZStack(alignment: .center) {
                            Circle() 
                                .frame(width: size, height: size)
                                .foregroundColor(Color.background)
                            
                            Image(systemName: "power")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.gray)
                        }.cornerRadius(size / 2)
                            .neumorphic()    
                    }                
                }
            }
        }
    }    
}

struct CustomToggleStyle_Previews: PreviewProvider {
    @State static var isOn: Bool = true
    
    static var previews: some View {
        Toggle(isOn: $isOn) {
            Text("Lowercase")
        }.toggleStyle(CustomToggleStyle())    
        
    }
}
