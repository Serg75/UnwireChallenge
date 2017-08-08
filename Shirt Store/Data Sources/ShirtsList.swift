//
//  ShirtsList.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation


/// This class loads the data from the server and stores it.
/// Also it gives parameters of shirts like sizes and colours.
class ShirtsList {

    static private var shirtsData = [Shirt]()
    
    
    /// Shirts list data from the server
    static var shirts: [Shirt] {
        return shirtsData
    }
    
    
    /// Loads the data from the server
    ///
    /// - Parameters:
    ///   - success: The completion handler to call when the load request is successul.
    ///   - fail:    The completion handler to call when the load request fails.
    static func loadShirts(success: @escaping () -> Void, fail: @escaping () -> Void) {
        
        DataManager.getShirtsWithSuccess(success: { (data) -> Void in
            var json: Any
            do {
                json = try JSONSerialization.jsonObject(with: data)
            } catch {
                print(error)
                return
            }
            
            guard let items = json as? [Any] else {
                print("Error: json data is not an array")
                return
            }
            
            Shirt.shirts(json: items, completion: { (shirts, error) in
                
                shirtsData = shirts
                
                if error != nil {
                    print("Parsing error: \(error!)")
                }
                
                success()
            })
            
        }, error: { (error) -> Void in
            print(error)
            fail()
        })

    }
    
    
    /// Available shirt sizes in the store
    static var sizes: [Shirt.Size] {
        return Array(Set(shirtsData.map { $0.size }))
    }

    
    /// Available shirt colours in the store
    static var colours: [String] {
        return Array(Set(shirtsData.map { $0.colour }))
    }
}
