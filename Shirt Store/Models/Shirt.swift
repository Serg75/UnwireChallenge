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
    enum Size: String {
        case XS, S, M, L, XL, XXL, XXXL
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
