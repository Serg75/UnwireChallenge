//
//  DataProviderTests.swift
//  Shirt Store
//
//  Created by Sergey S. on 15/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import XCTest

class DataProviderTests: XCTestCase {
    
    let dataProvider = MockDataProvider()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadData() {
        let testBundle = Bundle(for: type(of: self))
        
        // 1. Wrong file
        dataProvider.jsonFileUrl = testBundle.url(forResource: "no_shirts", withExtension: "json")

        dataProvider.loadData { (data, error) in
            XCTAssert(error != nil, "MockDataProvider test failed")
            XCTAssert(data == nil, "MockDataProvider test failed")
        }

        // 2. Correct file
        dataProvider.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")

        dataProvider.loadData { (data, error) in
            XCTAssert(error == nil, "MockDataProvider test failed")
            XCTAssert(data != nil, "MockDataProvider test failed")

            var json: Any
            do {
                json = try JSONSerialization.jsonObject(with: data!)
            } catch {
                XCTAssertThrowsError("MockDataProvider test failed")
                return
            }
            
            guard let items = json as? [Any] else {
                XCTAssertThrowsError("MockDataProvider test failed")
                return
            }
            
            XCTAssert(items.count == 14, "MockDataProvider test failed")
            
            guard let item1 = items[0] as? [String: Any] else {
                XCTAssertThrowsError("MockDataProvider test failed")
                return
            }
            
            XCTAssert(item1.count == 7, "MockDataProvider test failed")
            
            if let value = item1["id"] as? Int64 {
                XCTAssert(value == Int64(0), "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
            
            if let value = item1["price"] as? Int64 {
                XCTAssert(value == Int64(88), "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
            
            if let value = item1["picture"] as? String {
                XCTAssert(value == "https://unsplash.it/128/128", "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
            
            if let value = item1["colour"] as? String {
                XCTAssert(value == "brown", "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
            
            if let value = item1["size"] as? String {
                XCTAssert(value == "m", "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
            
            if let value = item1["name"] as? String {
                XCTAssert(value == "Southview Clarke", "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
            
            if let value = item1["quantity"] as? Int {
                XCTAssert(value == 0, "MockDataProvider test failed")
            } else {
                XCTAssertThrowsError("MockDataProvider test failed")
            }
        }
    }
    
    func testLoadImage() {
        let testBundle = Bundle(for: type(of: self))
        let link = testBundle.path(forResource: "test", ofType: "png")
        dataProvider.loadImageFrom(link: link!) { image in
            XCTAssert(image != nil, "MockDataProvider test failed")
            XCTAssert(image != nil, "MockDataProvider test failed")
            XCTAssert(image!.size == CGSize(width: 300, height: 300), "MockDataProvider test failed")
        }
    }
    
    func testSendOrder() {
        
        // empty order
        
        dataProvider.sendOrder(orderData: [String : Any]()) { error in
            XCTAssert(error == nil, "MockDataProvider test failed")
        }

        // real order
        
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
        
        let order = Shirt.orderData(items: [shirt], totalPrice: price)
        
        dataProvider.sendOrder(orderData: order) { error in
            XCTAssert(error == nil, "MockDataProvider test failed")
            readyExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "MockDataProvider test failed")
        })
    }
}
