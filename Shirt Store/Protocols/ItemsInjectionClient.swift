//
//  ItemsInjectionClient.swift
//  Shirt Store
//
//  Created by Sergey S. on 25/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

/// Interface for dependency injection.
protocol ItemsInjectionClient {
    
    /// Perform dependency injection.
    ///
    /// - Parameters:
    ///   - provider:   Data provider
    ///   - shirtsList: Shirts list object
    ///   - bagList:    Bag list object
    func set(provider: DataProvider, shirtsList: ShirtsList, bagList: BagList)
}
