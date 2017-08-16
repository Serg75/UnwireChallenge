//
//  DataManagerTests.swift
//  Shirt Store
//
//  Created by Sergey S. on 15/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import XCTest

class DataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let provider = MockDataProvider()
        let testBundle = Bundle(for: type(of: self))
        provider.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")
        DataManager.provider = provider
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetShirts() {
        DataManager.getShirtsWithSuccess(success: { data in
            XCTAssert(data.count > 0, "DataManager test failed")
            
            var json: Any
            do {
                json = try JSONSerialization.jsonObject(with: data)
            } catch {
                XCTAssertThrowsError("DataManager test failed")
                return
            }
            
            guard let items = json as? [Any] else {
                XCTAssertThrowsError("DataManager test failed")
                return
            }

            XCTAssert(items.count == 14, "DataManager test failed")

            guard let item1 = items[0] as? [String: Any] else {
                XCTAssertThrowsError("DataManager test failed")
                return
            }
            
            XCTAssert(item1.count == 7, "DataManager test failed")

            if let value = item1["id"] as? Int64 {
                XCTAssert(value == Int64(0), "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

            if let value = item1["price"] as? Int64 {
                XCTAssert(value == Int64(88), "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

            if let value = item1["picture"] as? String {
                XCTAssert(value == "https://unsplash.it/128/128", "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

            if let value = item1["colour"] as? String {
                XCTAssert(value == "brown", "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

            if let value = item1["size"] as? String {
                XCTAssert(value == "m", "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

            if let value = item1["name"] as? String {
                XCTAssert(value == "Southview Clarke", "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

            if let value = item1["quantity"] as? Int {
                XCTAssert(value == 0, "DataManager test failed")
            } else {
                XCTAssertThrowsError("DataManager test failed")
            }

        }) { error in
            XCTAssertThrowsError("DataManager test failed")
        }
    }
    
    func testGetImage() {
        let testBundle = Bundle(for: type(of: self))
        let link = testBundle.path(forResource: "test", ofType: "png")

        DataManager.getImageFrom(link: link!) { image in
            XCTAssert(image != nil, "DataManager test failed")
            XCTAssert(image!.size == CGSize(width: 300, height: 300), "DataManager test failed")
        }
    }
    
    func testSendOrder() {
        let id = Int64(1749324)
        let name = "Shirt Name"
        let price = Int64(1028)
        let colour = "magenta"
        let quantity = 5
        let size = Shirt.Size.XL
        let picture = "some_address"
        
        let shirt = Shirt(id: id,
                          name: name,
                          price: price,
                          colour: colour,
                          quantity: quantity,
                          size: size,
                          picture: picture)

        let readyExpectation = expectation(description: "ready")
        
        DataManager.sendOrder(items: [shirt], totalPrice: price, success: { 
            readyExpectation.fulfill()
        }) { error in
            XCTAssertThrowsError("DataManager test failed")
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "DataManager test failed")
        })
    }
    
}
