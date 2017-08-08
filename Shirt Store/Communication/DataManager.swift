//
//  DataManager.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation


/// Interface for data loader object.
protocol DataProvider {
    func loadData(completion: @escaping (_ data: Data?, _ error: Error?) -> Void);
}


/// Class for getting/sending data.
/// By default it uses standard server.
/// For using another server or local files set 'provider' property.
class DataManager {
    
    /// Object that provides a real connection between this class and data source
    static var provider: DataProvider!

    class func getShirtsWithSuccess(success: @escaping ((_ data: Data) -> Void), error: @escaping ((_ error: Error) -> Void)) {
        
        // default provider
        if provider == nil {
            provider = UrlDataProvider()
        }
        
        provider.loadData { (data, innerError) -> Void in
            if let data = data {
                success(data)
            } else {
                error(innerError!)
            }
        }
    }
}
