//
//  PasswordViewModel.swift
//  LassPassClone
//
//  Created by Vinh Nguyen Dinh on 2020/05/27.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import Foundation

struct PasswordViewModel: Identifiable {
    var id: UUID
    var site: String
    var username: String
    var password: String
    var createdAt: Date
    var note: String
    var lastUsed: Date
    var isFavorite: Bool
    
    init(passwordItem: PasswordItem) {
        self.id = passwordItem.id
        self.site = passwordItem.site
        self.username = passwordItem.username
        self.password = passwordItem.password
        self.createdAt = passwordItem.createdAt
        self.isFavorite = passwordItem.isFavorite
        self.note = passwordItem.note
        self.lastUsed = passwordItem.lastUsed
    }
}
