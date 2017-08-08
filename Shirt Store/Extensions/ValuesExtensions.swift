//
//  ValuesExtensions.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

extension Int {
    var formattedQuantity: String {
        switch self {
        case 0:
            return "This item is sold out."
        case 1..<Int.max:
            return "\(self) items"
        default:
            return ""
        }
    }
}
