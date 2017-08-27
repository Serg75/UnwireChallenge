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
    
    func testShirtSize() {
        
        // uppercase
        
        let sizeXS = Shirt.Size(string: "XS")
        XCTAssertNotNil(sizeXS, "Shirt size initialization test failed")

        let sizeS = Shirt.Size(string: "S")
        XCTAssertNotNil(sizeS, "Shirt size initialization test failed")

        let sizeM = Shirt.Size(string: "M")
        XCTAssertNotNil(sizeM, "Shirt size initialization test failed")
    
        let sizeL = Shirt.Size(string: "L")
        XCTAssertNotNil(sizeL, "Shirt size initialization test failed")
        
        let sizeXL = Shirt.Size(string: "XL")
        XCTAssertNotNil(sizeXL, "Shirt size initialization test failed")
        
        let sizeXXL = Shirt.Size(string: "XXL")
        XCTAssertNotNil(sizeXXL, "Shirt size initialization test failed")
        
        let sizeXXXL = Shirt.Size(string: "XXXL")
        XCTAssertNotNil(sizeXXXL, "Shirt size initialization test failed")

        // lowercase
        
        let size_xs = Shirt.Size(string: "xs")
        XCTAssertNotNil(size_xs, "Shirt size initialization test failed")
        
        let size_s = Shirt.Size(string: "s")
        XCTAssertNotNil(size_s, "Shirt size initialization test failed")
        
        let size_m = Shirt.Size(string: "m")
        XCTAssertNotNil(size_m, "Shirt size initialization test failed")
        
        let size_l = Shirt.Size(string: "l")
        XCTAssertNotNil(size_l, "Shirt size initialization test failed")
        
        let size_xl = Shirt.Size(string: "xl")
        XCTAssertNotNil(size_xl, "Shirt size initialization test failed")
        
        let size_xxl = Shirt.Size(string: "xxl")
        XCTAssertNotNil(size_xxl, "Shirt size initialization test failed")
        
        let size_xxxl = Shirt.Size(string: "xxxl")
        XCTAssertNotNil(size_xxxl, "Shirt size initialization test failed")

        // wrong data
        
        let wrongSize1 = Shirt.Size(string: "SSS")
        XCTAssertNil(wrongSize1, "Shirt size initialization test failed")

        let wrongSize2 = Shirt.Size(string: "a")
        XCTAssertNil(wrongSize2, "Shirt size initialization test failed")

        let wrongSize3 = Shirt.Size(string: "XXS")
        XCTAssertNil(wrongSize3, "Shirt size initialization test failed")
        
        // test string representation
        
        XCTAssert(sizeL?.string == "L", "Shirt size test failed")
        XCTAssert(sizeL?.string == size_l?.string, "Shirt size test failed")
        XCTAssert(sizeM?.string == size_m?.string, "Shirt size test failed")
        XCTAssert(sizeXXL?.string == size_xxl?.string, "Shirt size test failed")
        
        // test `Comparable` protocol
        
        XCTAssert(sizeL == size_l, "Shirt size test failed")
        XCTAssert(sizeXXL == size_xxl, "Shirt size test failed")
        XCTAssert(sizeXS! < sizeS!, "Shirt size test failed")
        XCTAssert(sizeS! < sizeM!, "Shirt size test failed")
        XCTAssert(sizeM! < sizeL!, "Shirt size test failed")
        XCTAssert(sizeL! < sizeXL!, "Shirt size test failed")
        XCTAssert(sizeXL! < sizeXXL!, "Shirt size test failed")
        XCTAssert(sizeXXL! < sizeXXXL!, "Shirt size test failed")
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

            //
            let json2 = shirt.json
            do {
                let shirt2 = try Shirt(json: json2)
                XCTAssert(shirt2.id == id, "Shirt initialization test failed")
                XCTAssert(shirt2.price == price, "Shirt initialization test failed")
                XCTAssert(shirt2.picture == picture, "Shirt initialization test failed")
                XCTAssert(shirt2.colour == colour, "Shirt initialization test failed")
                XCTAssert(shirt2.size == Shirt.Size.M, "Shirt initialization test failed")
                XCTAssert(shirt2.name == name, "Shirt initialization test failed")
                XCTAssert(shirt2.quantity == quantity, "Shirt initialization test failed")
            } catch {
                XCTAssertThrowsError("Shirt initialization test failed")
            }
        } catch {
            XCTAssertThrowsError("Shirt initialization test failed")
        }
        
        // test absence of values
        
        var errorJson = json
        errorJson.removeValue(forKey: "id")
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)
        
        errorJson = json
        errorJson.removeValue(forKey: "name")
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "price")
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "colour")
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "size")
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson.removeValue(forKey: "picture")
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson["name"] = ""
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson["price"] = Int64(-100)
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        errorJson = json
        errorJson["size"] = "aaa"
        XCTAssertThrowsError(try Shirt(json: errorJson), failedFromWrongDataMessage)

        // test negative quantity
        
        errorJson = json
        errorJson["quantity"] = -1
        do {
            let shirt = try Shirt(json: errorJson)
            XCTAssert(shirt.id == id, "Shirt initialization test failed")
            XCTAssert(shirt.price == price, "Shirt initialization test failed")
            XCTAssert(shirt.picture == picture, "Shirt initialization test failed")
            XCTAssert(shirt.colour == colour, "Shirt initialization test failed")
            XCTAssert(shirt.size == Shirt.Size.M, "Shirt initialization test failed")
            XCTAssert(shirt.name == name, "Shirt initialization test failed")
            XCTAssert(shirt.quantity == 0, "Shirt initialization test failed")
        } catch {
            XCTAssertThrowsError("Shirt initialization test failed")
        }
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
        
        let description = "\(name), \(colour) \(size), €\(price): \(quantity) items"
        XCTAssert(shirt.description == description, "Shirt description test failed")
        
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
