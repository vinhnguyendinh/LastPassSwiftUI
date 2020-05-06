//
//  StringExtensions.swift
//  LastPass
//
//  Created by Vinh Nguyen on 2020/05/06.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import UIKit

extension String {
    func getImageName() -> String {
        let urlComponents = self.lowercased().split(separator: ".")
        let count = urlComponents.count
        
        if urlComponents.isEmpty{
            return "placeholder"
        }
        return count > 2 ? String(urlComponents[count - 2]) : String(urlComponents.first ?? "")
    }
}
