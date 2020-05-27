//
//  FormHeader.swift
//  LastPass
//
//  Created by Vinh Nguyen on 2020/05/06.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct FormHeader: View {
    @Binding var showDetails: Bool
    @Binding var formType: FormType
    
    var body: some View {
        let imageName = "https://www.amazon.com".getImageName()
        
        return HStack {
            Button(action: {
                HapticFeedback.generate()
                withAnimation(.easeInOut) {
                    self.showDetails.toggle()
                }
            }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(Color.text)
            }
            
            Picker("", selection: self.$formType) {
                Text(FormType.Password.rawValue).tag(FormType.Password)
                Text(FormType.Note.rawValue).tag(FormType.Note)
            }.pickerStyle(SegmentedPickerStyle())
                .background(Color.background)
                .padding()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.gray)
            
        }.padding()
            .padding(.top)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.background)
            .shadow(color: Color.darkShadow, radius: 5, x: 0, y: 5)
    }
}

struct FormHeader_Previews: PreviewProvider {
    static var previews: some View {
        FormHeader(showDetails: .constant(true), formType: .constant(.Note))
    }
}
