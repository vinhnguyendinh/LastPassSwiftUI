//
//  PasswordGeneratorService.swift
//  LastPass
//
//  Created by Vinh Nguyen Dinh on 2020/05/18.
//  Copyright © 2020 Vinh Nguyen Dinh. All rights reserved.
//

import Combine
import SwiftUI

class PasswordGeneratorService: ObservableObject {
    struct Options {
        var lowercase = true
        var uppercase = false
        var specialCharacters = true
        var digits = false
        var length: CGFloat = 6
    }
    
    @Published var password: String = ""
    private let uppercaseCharacters = "abcdefghijklmnopqrstuvwxyz".uppercased()
    private let lowercaseCharacters = "abcdefghijklmnopqrstuvwxyz"
    private let digits = "0123456789"
    private let specialCharacters = "!@#$%^&*(){}[]:?/\\|"
    @Published var options = Options()

    private var cancellable: AnyCancellable?

    var generatePassowordPublisher: AnyPublisher<String, Never> {
        self.$options.debounce(for: 0.3, scheduler: RunLoop.main)
            .map {[unowned self] options in
                return self.generatePassword(with: options)
        }.eraseToAnyPublisher()
    }
    
    func generatePassword(with options: Options) -> String {
        var charOptions = ""
        
        if options.lowercase {
            charOptions += lowercaseCharacters
        }
        
        if options.uppercase {
            charOptions += uppercaseCharacters
        }
        
        if options.digits {
            charOptions += digits
        }
        
        if options.specialCharacters {
            charOptions += specialCharacters
        }
        
        if charOptions.count <= 0 {
            return ""
        }
        
        var newPassword = ""
        for _ in 0...Int(options.length) {
            let char = Array(charOptions)[Int.random(in: 0..<charOptions.count)]
            newPassword.append(char)
        }
        
        return newPassword
    }
    
    init() {        
        self.cancellable = self.generatePassowordPublisher
            .assign(to: \.password, on: self)
    }
}
