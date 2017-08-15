//
//  BagItems.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation


/// Notification for changing bag.
let bagItemsNotification = Notification.Name("BagItemDidChangeNotification")


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
        notifyForCollection()
    }
    
    
    /// Removes item from the bag.
    ///
    /// - Parameter item: Item to remove.
    static func removeFromBag(item: Shirt) {
        if let idx = itemsList.index(where: { $0.id == item.id } ) {
            itemsList.remove(at: idx)
            notifyForCollection()
        }
    }
    
    /// Removes all items from the bag.
    static func clear() {
        itemsList.removeAll()
        notifyForCollection()
    }
    
    
    /// Increases item's quantity by 1 if the store has enough quantity of the specified item.
    /// Otherwise the item's quantity doesn't change.
    /// Other classes should listen the 'BagItemDidChangeNotification' to be informed on changes.
    ///
    /// - Parameter item: Specified item to change quantity.
    static func increaseQuantity(item: Shirt) {
        if let idx = itemsList.index(where: { $0.id == item.id }) {
            if itemsList[idx].changeQuantityBy(1) {
                notifyForItem(item.id)
            }
        }
    }
    
    /// Decreases item's quantity by 1 if its current value is more than 1.
    /// Otherwise the item's quantity doesn't change.
    /// Other classes should listen the 'BagItemDidChangeNotification' to be informed on changes.
    ///
    /// - Parameter item: Specified item to change quantity.
    static func reduceQuantity(item: Shirt) {
        if let idx = itemsList.index(where: { $0.id == item.id }) {
            if itemsList[idx].changeQuantityBy(-1) {
                notifyForItem(item.id)
            }
        }
    }
    
    
    /// Send notification about collection change.
    private static func notifyForCollection() {
        NotificationCenter.default.post(name: bagItemsNotification, object: nil)
    }

    
    /// Send notification about item in collection change.
    ///
    /// - Parameter itemId: Item's id which data has been changed.
    private static func notifyForItem(_ itemId: Int64) {
        NotificationCenter.default.post(name: bagItemsNotification, object: ["id": itemId])
    }

    /// Determines whether specified item in the bag.
    ///
    /// - Parameter item:   Item to check
    /// - Returns:          True if the item in the bag
    static func isItemInBag(_ item: Shirt) -> Bool {
        return itemsList.contains(where: { return $0.id == item.id })
    }
    
    
    /// The total number of items in the bag.
    /// Don't use 'BagItems.items.cont' which gives the number of lots.
    static var itemsCount: Int {
        return itemsList.reduce(0) { $0 + $1.quantity }
    }
    
    /// Total price for all items in the bag.
    static var itemsPrice: Int64 {
        return itemsList.reduce(Int64(0)) { $0 + $1.price * Int64($1.quantity) }
    }
    
    
    /// Call this method right after successful load of the items from the server.
    static func restoreItems() {
        if let myItems = UserDefaults.standard.array(forKey: myBagKey) as? [[String: NSNumber]] {
            
            var myShirts = [Shirt]()
            ShirtsList.shirts.forEach({ shirt in
                if let myItem = myItems.first(where: { dictItem -> Bool in
                    if let id = dictItem["id"] {
                        return Int64(id) == shirt.id
                    }
                    return false
                }) {
                    var myShirt = shirt
                    if let quantity = myItem["quantity"] {
                        myShirt.quantity = Int(quantity)
                    } else {
                        myShirt.quantity = 1
                    }
                    myShirts.append(myShirt)
                }
            })
            itemsList = myShirts
        }
    }
    
    
    /// Call this method before terminating or going app to the background.
    static func saveItems() {
        let itemsIDs = itemsList.map { ["id": NSNumber(value: $0.id), "quantity": NSNumber(value: $0.quantity)] } as [[String: NSNumber]]
        UserDefaults.standard.set(itemsIDs, forKey: myBagKey)
    }
}
