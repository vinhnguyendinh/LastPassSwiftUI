//
//  Filter.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/01.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import Foundation

enum Filter: String, CaseIterable {
    case AllItems = "All Items"
    case Passwords
    case Notes
    case MostUsed = "Most Used"
    case Favorites
}
