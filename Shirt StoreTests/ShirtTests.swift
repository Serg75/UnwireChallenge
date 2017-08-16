//
//  Shirt_StoreTests.swift
//  Shirt StoreTests
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import XCTest
@testable import Shirt_Store

class ShirtTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShirtInitializer() {

        let failedFromWrongDataMessage = "Shirt initialization from corrupted data test failed"
        
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)
        
        // There is probably Swift error.
        // We can only feed the initializer by strictly typed values.
        // If we write 'let id = 55' the initializer will fail
        let id: Int64 = 55
        let price: Int64 = 88
        let picture = "https://unsplash.it/128/128"
        let colour = "brown"
        let name = "Southview Clarke"
        let quantity = 75
        
        let json: [String: Any] = [
            "id": id,
            "price": price,
            "picture": picture,
            "colour": colour,
            "size": "m",
            "name": name,
            "quantity": quantity ]
        
        do {
            let shirt = try Shirt(json: json)
            XCTAssert(shirt.id == id, "Shirt initialization test failed")
            XCTAssert(shirt.price == price, "Shirt initialization test failed")
            XCTAssert(shirt.picture == picture, "Shirt initialization test failed")
            XCTAssert(shirt.colour == colour, "Shirt initialization test failed")
            XCTAssert(shirt.size == Shirt.Size.M, "Shirt initialization test failed")
            XCTAssert(shirt.name == name, "Shirt initialization test failed")
            XCTAssert(shirt.quantity == quantity, "Shirt initialization test failed")
        } catch {
            XCTAssertThrowsError("Shirt initialization test failed")
        }
        
        var errorJson = json
        errorJson.removeValue(forKey: "id")
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)
        
        errorJson = json
        errorJson.removeValue(forKey: "name")
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "price")
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "colour")
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "size")
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "picture")
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson["name"] = ""
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson["price"] = -100
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)

        errorJson = json
        errorJson["size"] = "aaa"
        XCTAssertThrowsError(try Shirt(json: [String: Any]()), failedFromWrongDataMessage)
        
    }
    
    func testShirt() {
        let id = Int64(1749324)
        let name = "Shirt Name"
        let price = Int64(1028)
        let colour = "magenta"
        let quantity = 5
        let size = Shirt.Size.XL
        let picture = "some_address"
        
        var shirt = Shirt(id: id,
                          name: name,
                          price: price,
                          colour: colour,
                          quantity: quantity,
                          size: size,
                          picture: picture)
        
        XCTAssert(shirt.id == id, "Shirt memberwise initializer test failed")
        XCTAssert(shirt.name == name, "Shirt memberwise initializer test failed")
        XCTAssert(shirt.price == price, "Shirt memberwise initializer test failed")
        XCTAssert(shirt.colour == colour, "Shirt memberwise initializer test failed")
        XCTAssert(shirt.quantity == quantity, "Shirt memberwise initializer test failed")
        XCTAssert(shirt.size == size, "Shirt memberwise initializer test failed")
        XCTAssert(shirt.picture == picture, "Shirt memberwise initializer test failed")
        
        var result = shirt.changeQuantityBy(10)
        XCTAssert(result == true, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.id == id, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.name == name, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.price == price, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.colour == colour, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.quantity == quantity + 10, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.size == size, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.picture == picture, "Shirt changeQuantityBy function test failed")

        result = shirt.changeQuantityBy(-100)
        XCTAssert(result == false, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.id == id, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.name == name, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.price == price, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.colour == colour, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.quantity == quantity + 10, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.size == size, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.picture == picture, "Shirt changeQuantityBy function test failed")

        result = shirt.changeQuantityBy(-10)
        XCTAssert(result == true, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.id == id, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.name == name, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.price == price, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.colour == colour, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.quantity == quantity, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.size == size, "Shirt changeQuantityBy function test failed")
        XCTAssert(shirt.picture == picture, "Shirt changeQuantityBy function test failed")
}
    
    func testShirtListInitializer() {
        var id: Int64 = 55
        var price: Int64 = 88
        var picture = "https://unsplash.it/128/128"
        var colour = "brown"
        var name = "Southview Clarke"
        var quantity = 75
        
        let item1: [String: Any] = [
            "id": id,
            "price": price,
            "picture": picture,
            "colour": colour,
            "size": "m",
            "name": name,
            "quantity": quantity ]

        id = 56
        price = 63
        picture = "https://unsplash.it/200/200"
        colour = "green"
        name = "Westboro Frank"
        quantity = 0
        
        let item2: [String: Any] = [
            "id": id,
            "price": price,
            "picture": picture,
            "colour": colour,
            "size": "s",
            "name": name,
            "quantity": quantity ]

        // wrong data
        let item3: [String: Any] = [
            "id": id,
            "price": price,
            "picture": picture,
            "colour": colour,
            "size": "---",
            "name": name,
            "quantity": quantity ]
        
        let json = [item1, item2, item3]
        
        Shirt.shirts(json: json) { (shirts, error) in
            XCTAssert(shirts.count == 2, "Shirt initialization test failed")
            XCTAssert(error != nil, "Shirt initialization test failed")
        }
    }
    
}
