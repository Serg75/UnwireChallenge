//
//  FiltersDataSourceTest.swift
//  Shirt Store
//
//  Created by Sergey S. on 27/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import XCTest
import UIKit

class FiltersDataSourceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFiltersDataSource() {
        
        let errorMessage = "FiltersDataSource test failed"
        
        let testBundle = Bundle(for: type(of: self))
        
        let provider = MockDataProvider()
        provider.jsonFileUrl = testBundle.url(forResource: "shirts", withExtension: "json")
        let shirtsList = Shirts(provider: provider)

        let source = FiltersDataSource()
        source.set(provider: provider, shirtsList: shirtsList, bagList: BagItems())
        
        let tableView = UITableView()
        
        XCTAssert(source.numberOfSections(in: tableView) == 2, errorMessage)

        XCTAssert(source.tableView(tableView, titleForHeaderInSection: 0) == "Size", errorMessage)
        XCTAssert(source.tableView(tableView, titleForHeaderInSection: 1) == "Colour", errorMessage)
        
        XCTAssert(source.tableView(tableView, numberOfRowsInSection: 0) == shirtsList.sizes.count, errorMessage)
        XCTAssert(source.tableView(tableView, numberOfRowsInSection: 1) == shirtsList.colours.count, errorMessage)
    }
    
}
