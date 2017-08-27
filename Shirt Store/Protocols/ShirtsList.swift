//
//  ShirtsList.swift
//  Shirt Store
//
//  Created by Sergey S. on 25/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

/// Interface for object that stores shirts list and
/// gives parameters of shirts like sizes and colours.
protocol ShirtsList {
    
    /// Filters by sizes.
    /// When this field has non-empty value only shirts with specified sizes
    /// are returned by 'shirts' field.
    var filterSizes: Set<Shirt.Size> { get set }
    
    /// Filters by colours.
    /// When this field has non-empty value only shirts with specified colours
    /// are returned by 'shirts' field.
    var filterColours: Set<String> { get set }
    
    /// The total number of filters selected for narrow the shirts list.
    var selectedFiltersCount: Int { get }
    
    /// Returns true when shirt list has any item.
    /// Filters don't change this field.
    var hasShirts: Bool { get }
    
    /// Shirts list data from the server
    var shirts: [Shirt] { get }
    
    
    /// Loads the data from the server
    ///
    /// - Parameters:
    ///   - success: The completion handler to call when the load request is successul.
    ///   - fail:    The completion handler to call when the load request fails.
    func loadShirts(success: @escaping () -> Void, fail: @escaping (_ error: Error) -> Void)
    
    /// Available shirt sizes in the store
    var sizes: [Shirt.Size] { get }
    
    /// Available shirt colours in the store
    var colours: [String] { get }
    
    /// Available shirts's quantity in the store.
    ///
    /// - Parameter shirt:  Shirt which quantity we need to find.
    /// - Returns:          The quantity of the shirt in the store.
    func quantityForShirt(_ shirt: Shirt) -> Int
}
