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
            
            XCTAssert(json is [Any], "MockDataProvider test failed")
        }
    }
    
    func testLoadImage() {
        let testBundle = Bundle(for: type(of: self))
        let link = testBundle.path(forResource: "test", ofType: "png")
        dataProvider.loadImageFrom(link: link!) { image in
            XCTAssert(image != nil, "MockDataProvider test failed")
        }
    }
    
    func testSendOrder() {
        dataProvider.sendOrder(orderData: [String : Any]()) { error in
            XCTAssert(error == nil, "MockDataProvider test failed")
        }
    }
}
