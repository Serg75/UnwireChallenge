//
//  BagItemsTest.swift
//  Shirt Store
//
//  Created by Sergey S. on 27/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import XCTest

class BagItemsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBagItems() {
        
        let bagItems = BagItems()
        
        XCTAssert(bagItems.items.count == 0, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 0, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == 0, "BagItems test failed")

        
        let id = Int64(1749324)
        let name = "Shirt Name"
        let price = Int64(1028)
        let colour = "magenta"
        let quantity = 2
        let size = Shirt.Size.XL
        let picture = "some_address"
        
        let shirt1 = Shirt(id: id,
                           name: name,
                           price: price,
                           colour: colour,
                           quantity: quantity,
                           size: size,
                           picture: picture)

        XCTAssert(!bagItems.isItemInBag(shirt1), "BagItems test failed")
        
        bagItems.addToBag(item: shirt1)
        XCTAssert(bagItems.isItemInBag(shirt1), "BagItems test failed")
        XCTAssert(bagItems.items.count == 1, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 2, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price * 2, "BagItems test failed")
        
        let shirt2 = Shirt(id: Int64(555),
                           name: "Shirt Name 2",
                           price: price,
                           colour: colour,
                           quantity: quantity,
                           size: size,
                           picture: picture)


        bagItems.addToBag(item: shirt2)
        XCTAssert(bagItems.isItemInBag(shirt2), "BagItems test failed")
        XCTAssert(bagItems.items.count == 2, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 4, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price * 4, "BagItems test failed")

        // add existed shirt
        
        bagItems.addToBag(item: shirt1)
        XCTAssert(bagItems.isItemInBag(shirt1), "BagItems test failed")
        XCTAssert(bagItems.items.count == 2, "BagItems test failed")
        
        // quantity
        
        bagItems.increaseQuantity(item: shirt1)
        XCTAssert(bagItems.items.count == 2, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 5, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price * 5, "BagItems test failed")
        
        bagItems.reduceQuantity(item: shirt2)
        XCTAssert(bagItems.items.count == 2, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 4, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price * 4, "BagItems test failed")
        
        bagItems.reduceQuantity(item: shirt1)
        XCTAssert(bagItems.items.count == 2, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 3, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price * 3, "BagItems test failed")

        // test minimum quantity is equal 1
        
        bagItems.reduceQuantity(item: shirt2)
        XCTAssert(bagItems.items.count == 2, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 3, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price * 3, "BagItems test failed")

        bagItems.removeFromBag(item: shirt1)
        XCTAssert(!bagItems.isItemInBag(shirt1), "BagItems test failed")
        XCTAssert(bagItems.items.count == 1, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 1, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == price, "BagItems test failed")
        
        // remove shirt that is not in the bag

        bagItems.removeFromBag(item: shirt1)
        XCTAssert(!bagItems.isItemInBag(shirt1), "BagItems test failed")
        XCTAssert(bagItems.items.count == 1, "BagItems test failed")
        
        bagItems.clear()
        XCTAssert(bagItems.items.count == 0, "BagItems test failed")
        XCTAssert(bagItems.itemsCount == 0, "BagItems test failed")
        XCTAssert(bagItems.itemsPrice == 0, "BagItems test failed")

        bagItems.addToBag(item: shirt1)

    }
    
}
