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
    
    func testLoadShirts() {

        let testBundle = Bundle(for: type(of: self))

        // 1. Wrong sourse data
        
        let provider1 = MockDataProvider()
        provider1.jsonFileUrl = testBundle.url(forResource: "no_shirts", withExtension: "json")
        var shirtsList = Shirts(provider: provider1)

        let readyExpectation1 = expectation(description: "ready")
        
        shirtsList.loadShirts(success: {
            XCTAssertThrowsError("ShirtsList test failed")
        }) { _ in
            readyExpectation1.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })
        
        XCTAssert(shirtsList.shirts.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == false, "ShirtsList test failed")
        XCTAssert(shirtsList.sizes.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.colours.count == 0, "ShirtsList test failed")

        // 2. Correct sourse data

        let provider2 = MockDataProvider()
        provider2.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")
        shirtsList = Shirts(provider: provider2)

        let readyExpectation2 = expectation(description: "ready")
        
        shirtsList.loadShirts(success: { 
            readyExpectation2.fulfill()
        }) { _ in 
            XCTAssertThrowsError("ShirtsList test failed")
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })

        XCTAssert(shirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")
        XCTAssert(shirtsList.sizes.count == 3, "ShirtsList test failed")
        XCTAssert(shirtsList.colours.count == 3, "ShirtsList test failed")
        
        let shirt1 = shirtsList.shirts[0]
        let quantity = shirt1.quantity
        XCTAssert(shirtsList.quantityForShirt(shirt1) == quantity, "ShirtsList test failed")
    }
    
    func testFilters() {
        
        // 1. Preparation
        
        let testBundle = Bundle(for: type(of: self))
        
        let provider = MockDataProvider()
        provider.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")
        let shirtsList = Shirts(provider: provider)
        
        let readyExpectation = expectation(description: "ready")
        
        shirtsList.loadShirts(success: {
            readyExpectation.fulfill()
        }) { _ in 
            XCTAssertThrowsError("ShirtsList test failed")
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "ShirtsList test failed")
        })
        
        XCTAssert(shirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")
        XCTAssert(shirtsList.sizes.count == 3, "ShirtsList test failed")
        XCTAssert(shirtsList.colours.count == 3, "ShirtsList test failed")

        // 2. Test
        
        shirtsList.filterSizes = Set([Shirt.Size.L])
        XCTAssert(shirtsList.shirts.count == 4, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 1, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 1, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")

        shirtsList.filterSizes.insert(Shirt.Size.M)
        XCTAssert(shirtsList.shirts.count == 9, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 2, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 2, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")

        // Shouldn't change anything
        
        shirtsList.filterSizes.insert(Shirt.Size.L)
        XCTAssert(shirtsList.shirts.count == 9, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 2, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 2, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")
        
        shirtsList.filterColours = Set(["brown"])
        XCTAssert(shirtsList.shirts.count == 7, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 2, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 1, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 3, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")

        // Clear filters
        
        shirtsList.filterSizes = []
        shirtsList.filterColours = []
        XCTAssert(shirtsList.shirts.count == 10, "ShirtsList test failed")
        XCTAssert(shirtsList.filterSizes.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.filterColours.count == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.selectedFiltersCount == 0, "ShirtsList test failed")
        XCTAssert(shirtsList.hasShirts == true, "ShirtsList test failed")
    }
}
