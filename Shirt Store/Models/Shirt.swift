//
//  Shirt.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation


/// Model for Shirt
struct Shirt {
    enum Size: Int, Comparable {
        case XS, S, M, L, XL, XXL, XXXL
        
        init?(string: String) {
            switch string.uppercased() {
            case "XS":
                self = .XS
            case "S":
                self = .S
            case "M":
                self = .M
            case "L":
                self = .L
            case "XL":
                self = .XL
            case "XXL":
                self = .XXL
            case "XXXL":
                self = .XXXL
            default:
                return nil
            }
        }
        
        var string: String {
            return "\(self)"
        }
        
        // The only requirement of the `Comparable` protocol.
        static func <(lhs: Size, rhs: Size) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    let id: Int64
    let name: String
    let price: Int64
    let colour: String
    let quantity: Int
    let size: Size
    let picture: String
    
    var description: String {
        return "\(name), \(colour) \(size), €\(price): \(quantity) items"
    }
}
