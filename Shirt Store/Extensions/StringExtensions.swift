//
//  StringExtensions.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

extension String {
    
    /// A Boolean value indicating whether a first character is uppercase.
    func isFirstCharacterUppercase() -> Bool {
        if let char = self.unicodeScalars.first {
            return CharacterSet.uppercaseLetters.contains(char)
        }
        return false
    }
}
