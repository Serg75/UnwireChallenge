//
//  ShirtSerialization.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

extension Shirt {
    
    /// Initializer for Shirt.
    ///
    /// - Parameter json:   A json object with data for Shirt initialization.
    /// - Throws:           If json data contains invalid data the initializer throws 
    ///                     a descriptive error.
    init(json: [String: Any]) throws {
        guard let id = json["id"] as? Int64 else {
            throw ParsingError.missing("id")
        }
        
        guard let name = json["name"] as? String else {
            throw ParsingError.missing("name for item \(id)")
        }
        
        guard !name.isEmpty,
            name.isFirstCharacterUppercase() else {
                throw ParsingError.invalid("name for item \(id)", name)
        }
        
        guard let price = json["price"] as? Int64 else {
            throw ParsingError.missing("price for item \(id)")
        }
        guard price >= 0 else {
            throw ParsingError.invalid("price for item \(id)", price)
        }
        
        guard let colour = json["colour"] as? String else {
            throw ParsingError.missing("colour for item \(id)")
        }
        
        guard let sizeString = json["size"] as? String,
            let size = Size(string: sizeString) else {
                throw ParsingError.missing("size for item \(id)")
        }
        
        guard let picture = json["picture"] as? String else {
            throw ParsingError.missing("picture for item \(id)")
        }
        
        self.id = id
        self.name = name
        self.price = price
        self.colour = colour
        self.size = size
        self.picture = picture
        
        if let quantity = json["quantity"] as? Int {
            self.quantity = quantity
        } else {
            self.quantity = 0
        }
    }

    
    /// Initializer for list of Shirts
    ///
    /// - Parameters:
    ///   - json:       A json object with data for list initialization.
    ///   - completion: The completion handler to call when the initialization is complete.
    ///                 This handler is executed on the delegate queue.
    ///                 This completion handler takes list of Shirts and error as parameters.
    ///
    /// If any Shirt cannot initialize the initializer prints the error
    static func shirts(json: [Any], completion: @escaping ([Shirt], _ error: Error?) -> Void) {
        
        var shirts: [Shirt] = []
        var errorCount = 0
        var error: Error?
        
        for case let item in json {
            do {
                let shirt = try Shirt(json: item as! [String : Any])
                shirts.append(shirt)
            } catch let error {
                errorCount += 1
                print("Parsing error: \(error)")
            }
        }
        
        if errorCount > 0 {
            error = ParsingError.invalid("items", "There are \(errorCount) items with error data.")
        }
        
        completion(shirts, error)
    }
}
