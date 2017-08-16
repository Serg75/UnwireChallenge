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
    
    /// Filters by sizes.
    /// When this field has non-empty value only shirts with specified sizes
    /// are returned by 'shirts' field.
    static var filterSizes = Set<Shirt.Size>()
    
    /// Filters by colours.
    /// When this field has non-empty value only shirts with specified colours
    /// are returned by 'shirts' field.
    static var filterColours = Set<String>()
    
    /// The total number of filters selected for narrow the shirts list.
    static var selectedFiltersCount: Int {
        return filterSizes.count + filterColours.count
    }
    
    /// Returns true when shirt list has any item.
    /// Filters don't change this field.
    static var hasShirts: Bool {
        return shirtsData.count > 0
    }
    
    /// Shirts list data from the server
    static var shirts: [Shirt] {
        var filteredData = shirtsData
        if filterSizes.count > 0 {
            filteredData = filteredData.filter { filterSizes.contains($0.size) }
        }
        if filterColours.count > 0 {
            filteredData = filteredData.filter { filterColours.contains($0.colour) }
        }
        return filteredData
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
                
                BagItems.restoreItems()
                
                success()
            })
            
        }, fail: { (error) -> Void in
            print(error)
            fail()
        })
    }
    
    
    /// Available shirt sizes in the store
    static var sizes: [Shirt.Size] {
        return Array(Set(shirtsData.map { $0.size })).sorted()
    }

    
    /// Available shirt colours in the store
    static var colours: [String] {
        return Array(Set(shirtsData.map { $0.colour })).sorted()
    }
    
    
    /// Available shirts's quantity in the store.
    ///
    /// - Parameter shirt:  Shirt which quantity we need to find.
    /// - Returns:          The quantity of the shirt in the store.
    static func quantityForShirt(_ shirt: Shirt) -> Int {
        if let item = shirtsData.first(where: { $0.id == shirt.id }) {
            return item.quantity
        }
        return 0
    }
}
