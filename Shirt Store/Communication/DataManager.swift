//
//  DataManager.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit


/// Interface for data loader object.
protocol DataProvider {
    func loadData(completion: @escaping (_ data: Data?, _ error: Error?) -> Void);
    func loadImageFrom(link: String, completion: @escaping (_ image: UIImage?) -> Void);
}


/// Class for getting/sending data.
/// By default it uses standard server.
/// For using another server or local files set 'provider' property.
class DataManager {
    
    /// Object that provides a real connection between this class and data source
    static var provider: DataProvider!

    
    /// Loads shirts list.
    ///
    /// - Parameters:
    ///   - success:    The completion handler to call when the load request is successul.
    ///   - fail:      The completion handler to call when the load request fails.
    class func getShirtsWithSuccess(success: @escaping ((_ data: Data) -> Void), fail: @escaping ((_ error: Error) -> Void)) {
        
        // default provider
        if provider == nil {
            provider = UrlDataProvider()
        }
        
        provider.loadData { (data, innerFail) -> Void in
            if let data = data {
                success(data)
            } else {
                fail(innerFail!)
            }
        }
    }
    
    
    /// Retrieves an image from specified link.
    ///
    /// - Parameters:
    ///   - link:       Link to the image.
    ///   - completion: The completion handler to call when the image loading is complete.
    class func getImageFrom(link: String, completion: @escaping (_ image: UIImage?) -> Void) {
        provider.loadImageFrom(link: link) { (innerImage) in
            completion(innerImage)
        }
    }
}
