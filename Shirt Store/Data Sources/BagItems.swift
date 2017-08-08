//
//  BagItems.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

/// This class stores items in the bag.
class BagItems {
    
    // user defaults
    static private let myBagKey = "MyBagKey"
    
    static private var itemsList = [Shirt]()
    
    
    /// Items in the bag.
    static var items: [Shirt] {
        return itemsList
    }
    
    
    /// Adds item into the bag.
    ///
    /// - Parameter item: Item to add.
    static func addToBag(item: Shirt) {
        itemsList.append(item)
    }
    
    
    /// Removes item from the bag.
    ///
    /// - Parameter item: Item to remove.
    static func removeFromBag(item: Shirt) {
        if let idx = itemsList.index(where: { $0.id == item.id } ) {
            itemsList.remove(at: idx)
        }
    }
    
    /// Removes all items from the bag.
    static func clear() {
        itemsList.removeAll()
    }
    
    
    /// Determines whether specified item in the bag.
    ///
    /// - Parameter item:   Item to check
    /// - Returns:          True if the item in the bag
    static func isItemInBag(_ item: Shirt) -> Bool {
        return itemsList.contains(where: { return $0.id == item.id })
    }
    
    
    /// Total price for all items in the bag.
    static var itemsPrice: Int64 {
        return itemsList.reduce(Int64(0)) { $0 + $1.price * Int64($1.quantity) }
    }
    
    
    /// Call this method right after successful load of the items from the server.
    static func restoreItems() {
        if let itemsIDs = UserDefaults.standard.array(forKey: myBagKey) as? [Int64] {
            itemsList = ShirtsList.shirts.filter { itemsIDs.contains($0.id) }
        }
    }
    
    
    /// Call this method before terminating or going app to the background.
    static func saveItems() {
        let itemsIDs = itemsList.map { $0.id } as [Int64]
        UserDefaults.standard.set(itemsIDs, forKey: myBagKey)
    }
}
