//
//  ValuesExtensions.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

extension Int {
    func formattedQuantity(markSoldedOut: Bool = false) -> String {
        switch self {
        case 0:
            return markSoldedOut ? "This item is sold out." : "no items"
        case 1:
            return "1 item"
        case 2..<Int.max:
            return "\(self) items"
        default:
            return ""
        }
    }
}
