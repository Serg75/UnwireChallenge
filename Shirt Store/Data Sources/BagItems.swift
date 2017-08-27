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
class BagItems : BagList {
    
    // user defaults
    private let myBagKey = "MyBagKey"
    
    private var itemsList = [Shirt]()
    
    
    /// Items in the bag.
    var items: [Shirt] {
        return itemsList
    }
    
    
    /// Adds item into the bag.
    ///
    /// - Parameter item: Item to add.
    func addToBag(item: Shirt) {
        if !isItemInBag(item) {
            itemsList.append(item)
            notifyForCollection()
        }
    }
    
    
    /// Removes item from the bag.
    ///
    /// - Parameter item: Item to remove.
    func removeFromBag(item: Shirt) {
        if let idx = itemsList.index(where: { $0.id == item.id } ) {
            itemsList.remove(at: idx)
            notifyForCollection()
        }
    }
    
    /// Removes all items from the bag.
    func clear() {
        itemsList.removeAll()
        notifyForCollection()
    }
    
    
    /// Increases item's quantity by 1 if the store has enough quantity of the specified item.
    /// Otherwise the item's quantity doesn't change.
    /// Other classes should listen the 'BagItemDidChangeNotification' to be informed on changes.
    ///
    /// - Parameter item: Specified item to change quantity.
    func increaseQuantity(item: Shirt) {
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
    func reduceQuantity(item: Shirt) {
        if let idx = itemsList.index(where: { $0.id == item.id }) {
            if itemsList[idx].changeQuantityBy(-1) {
                notifyForItem(item.id)
            }
        }
    }
    
    
    /// Send notification about collection change.
    private func notifyForCollection() {
        NotificationCenter.default.post(name: bagItemsNotification, object: nil)
    }

    
    /// Send notification about item in collection change.
    ///
    /// - Parameter itemId: Item's id which data has been changed.
    private func notifyForItem(_ itemId: Int64) {
        NotificationCenter.default.post(name: bagItemsNotification, object: ["id": itemId])
    }

    /// Determines whether specified item in the bag.
    ///
    /// - Parameter item:   Item to check
    /// - Returns:          True if the item in the bag
    func isItemInBag(_ item: Shirt) -> Bool {
        return itemsList.contains(where: { return $0.id == item.id })
    }
    
    
    /// The total number of items in the bag.
    /// Don't use 'BagItems.items.cont' which gives the number of lots.
    var itemsCount: Int {
        return itemsList.reduce(0) { $0 + $1.quantity }
    }
    
    /// Total price for all items in the bag.
    var itemsPrice: Int64 {
        return itemsList.reduce(Int64(0)) { $0 + $1.price * Int64($1.quantity) }
    }
    
    
    /// Call this method to restore saved items.
    ///
    /// - Parameter shirts: Available shirts. Only shirts from this list will be restored. 
    func restoreItemsWithShirts(_ shirts: [Shirt]) {
        if let myItems = UserDefaults.standard.array(forKey: myBagKey) as? [[String: NSNumber]] {
            
            var myShirts = [Shirt]()
            shirts.forEach({ shirt in
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
    func saveItems() {
        let itemsIDs = itemsList.map { ["id": NSNumber(value: $0.id), "quantity": NSNumber(value: $0.quantity)] } as [[String: NSNumber]]
        UserDefaults.standard.set(itemsIDs, forKey: myBagKey)
    }
}
