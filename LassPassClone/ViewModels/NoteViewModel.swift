//
//  NoteViewModel.swift
//  LassPassClone
//
//  Created by Vinh Nguyen Dinh on 2020/05/27.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import Foundation

struct NoteViewModel: Identifiable {
    var id: UUID
    var name: String
    var content: String
    var isFavorite: Bool
    var createdAt: Date
    var lastUsed: Date
    
    init(noteItem: NoteItem) {
        self.id = noteItem.id
        self.name = noteItem.name
        self.content = noteItem.content
        self.isFavorite = noteItem.isFavorite
        self.createdAt = noteItem.createdAt
        self.lastUsed = noteItem.lastUsed
    }
}
