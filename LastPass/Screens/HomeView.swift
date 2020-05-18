//
//  HomeView.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var showMenu: Bool = true
    @State var showSearchField: Bool = true
    @State var showEditFormView = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                NavBar(showMenu: self.$showMenu, title: "Last pass", showSearchField: self.showSearchField)

                HeaderView { filter in }
                createList()
            }
            
            createFloatingButton()
        }
    }
    
    private func createList() -> some View {
        List {
            createPasswordsSection()
            createNotesSection()
        }.onAppear {
            UITableView.appearance().backgroundColor = UIColor(named: "bg")
            UITableView.appearance().separatorColor = .clear
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
    
    private func createPasswordsSection() -> some View {
        Section(header:
            SectionTitle(title: "Passwords")
        ) {
            ForEach(1..<5) { i in
                RowItem()
            }
        }
    }
    
    private func createNotesSection() -> some View {
        Section(header:
            SectionTitle(title: "Notes")
        ) {
            ForEach(1..<5) { i in
                RowItem()
            }
        }
    } 
    
    fileprivate func createFloatingButton() -> some View {
        Button(action: {
            HapticFeedback.generate()
            self.showEditFormView.toggle()
        }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.text)
                .padding()
                .background(Color.background)
                .cornerRadius(35)
                .neumorphic()
        }.padding(30)    
            .sheet(isPresented: self.$showEditFormView) {
                self.createEditFormView()
        }
    }
    
    fileprivate func createEditFormView() -> some View {
        return EditFormView(showDetails: .constant(false))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
