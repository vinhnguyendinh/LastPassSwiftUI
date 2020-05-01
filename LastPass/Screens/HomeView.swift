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
    
    var body: some View {
        VStack {
            NavBar(showMenu: self.$showMenu, title: "Last pass", showSearchField: self.showSearchField)
            
            HeaderView { filter in
                self.showSearchField = (filter == .AllItems)
            }
            
            self.createList()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
