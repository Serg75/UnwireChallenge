//
//  ShirtsListTests.swift
//  Shirt Store
//
//  Created by Sergey S. on 15/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import XCTest

class ShirtsListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Note!
    //
    // To pass this test run it before other tests which use ShirtsList class
    //
    func testInitialData() {
        XCTAssert(ShirtsList.shirts.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == false, "ShirtsList test failed")
        XCTAssert(ShirtsList.sizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.colours.count == 0, "ShirtsList test failed")
        
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

        XCTAssert(ShirtsList.quantityForShirt(shirt) == 0, "ShirtsList test failed")
    }
    
    func testLoadShirts() {

        let testBundle = Bundle(for: type(of: self))

        // 1. Wrong sourse data
        
        let provider1 = MockDataProvider()
        provider1.jsonFileUrl = testBundle.url(forResource: "no_shirts", withExtension: "json")
        DataManager.provider = provider1

        let readyExpectation1 = expectation(description: "ready")
        
        ShirtsList.loadShirts(success: {
            XCTAssertThrowsError("ShirtsList test failed")
        }) {
            readyExpectation1.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })
        
        XCTAssert(ShirtsList.shirts.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == false, "ShirtsList test failed")
        XCTAssert(ShirtsList.sizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.colours.count == 0, "ShirtsList test failed")

        // 2. Correct sourse data

        let provider2 = MockDataProvider()
        provider2.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")
        DataManager.provider = provider2

        let readyExpectation2 = expectation(description: "ready")
        
        ShirtsList.loadShirts(success: { 
            readyExpectation2.fulfill()
        }) { 
            XCTAssertThrowsError("ShirtsList test failed")
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })

        XCTAssert(ShirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")
        XCTAssert(ShirtsList.sizes.count == 3, "ShirtsList test failed")
        XCTAssert(ShirtsList.colours.count == 3, "ShirtsList test failed")

        // 3. Wrong sourse data again
        
        DataManager.provider = provider1
        
        let readyExpectation3 = expectation(description: "ready")
        
        ShirtsList.loadShirts(success: {
            XCTAssertThrowsError("ShirtsList test failed")
        }) {
            readyExpectation3.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })
        
        // ShirtsList shouldn't be changed
        XCTAssert(ShirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")
        XCTAssert(ShirtsList.sizes.count == 3, "ShirtsList test failed")
        XCTAssert(ShirtsList.colours.count == 3, "ShirtsList test failed")
    }
    
    func testFilters() {
        
        // 1. Preparation
        
        let testBundle = Bundle(for: type(of: self))
        
        let provider = MockDataProvider()
        provider.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")
        DataManager.provider = provider
        
        let readyExpectation = expectation(description: "ready")
        
        ShirtsList.loadShirts(success: {
            readyExpectation.fulfill()
        }) {
            XCTAssertThrowsError("ShirtsList test failed")
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })
        
        XCTAssert(ShirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")
        XCTAssert(ShirtsList.sizes.count == 3, "ShirtsList test failed")
        XCTAssert(ShirtsList.colours.count == 3, "ShirtsList test failed")

        // 2. Test
        
        ShirtsList.filterSizes = Set([Shirt.Size.L])
        XCTAssert(ShirtsList.shirts.count == 4, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 1, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 1, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")

        ShirtsList.filterSizes.insert(Shirt.Size.M)
        XCTAssert(ShirtsList.shirts.count == 9, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 2, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 2, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")

        // Shouldn't change anything
        
        ShirtsList.filterSizes.insert(Shirt.Size.L)
        XCTAssert(ShirtsList.shirts.count == 9, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 2, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 2, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")
        
        ShirtsList.filterColours = Set(["brown"])
        XCTAssert(ShirtsList.shirts.count == 7, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 2, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 1, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 3, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")

        // Clear filters
        
        ShirtsList.filterSizes = []
        ShirtsList.filterColours = []
        XCTAssert(ShirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(ShirtsList.hasShirts == true, "ShirtsList test failed")
    }
}
