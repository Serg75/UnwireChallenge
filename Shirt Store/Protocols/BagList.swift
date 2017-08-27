//
//  BagList.swift
//  Shirt Store
//
//  Created by Sergey S. on 25/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

/// Interface for object that stores items in the bag.
protocol BagList {
    
    /// Items in the bag.
    var items: [Shirt] { get }

    /// Adds item into the bag.
    ///
    /// - Parameter item: Item to add.
    func addToBag(item: Shirt)

    /// Removes item from the bag.
    ///
    /// - Parameter item: Item to remove.
    func removeFromBag(item: Shirt)

    /// Removes all items from the bag.
    func clear()

    /// Increases item's quantity by 1 if the store has enough quantity of the specified item.
    /// Otherwise the item's quantity doesn't change.
    /// Other classes should listen the 'BagItemDidChangeNotification' to be informed on changes.
    ///
    /// - Parameter item: Specified item to change quantity.
    func increaseQuantity(item: Shirt)

    /// Decreases item's quantity by 1 if its current value is more than 1.
    /// Otherwise the item's quantity doesn't change.
    /// Other classes should listen the 'BagItemDidChangeNotification' to be informed on changes.
    ///
    /// - Parameter item: Specified item to change quantity.
    func reduceQuantity(item: Shirt)

    /// Determines whether specified item in the bag.
    ///
    /// - Parameter item:   Item to check
    /// - Returns:          True if the item in the bag
    func isItemInBag(_ item: Shirt) -> Bool

    /// The total number of items in the bag.
    /// Don't use 'BagItems.items.cont' which gives the number of lots.
    var itemsCount: Int { get }

    /// Total price for all items in the bag.
    var itemsPrice: Int64 { get }

    /// Call this method to restore saved items.
    ///
    /// - Parameter shirts: Available shirts. Only shirts from this list will be restored.
    func restoreItemsWithShirts(_ shirts: [Shirt])

    /// Call this method before terminating or going app to the background.
    func saveItems()
}
