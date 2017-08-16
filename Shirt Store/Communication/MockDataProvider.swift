//
//  MockDataProvider.swift
//  Shirt Store
//
//  Created by Sergey S. on 15/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class MockDataProvider: DataProvider {

    var jsonFileUrl: URL!
    
    /// Loads shirts list from the server.
    ///
    /// - Parameter completion: The completion handler to call when the image loading is complete.
    func loadData(completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        guard jsonFileUrl != nil else {
            completion(nil, FileError.missing("jsonFileUrl"))
            return
        }
        
        do {
            if try !jsonFileUrl.checkResourceIsReachable() {
                completion(nil, FileError.invalid("jsonFileUrl"))
                return
            }
        } catch {
            completion(nil, error)
            return
        }

        do {
            let data = try Data(contentsOf: jsonFileUrl)
            completion(data, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    
    /// Retrieves an image from specified internet resource.
    ///
    /// - Parameters:
    ///   - link:       Link to the image.
    ///   - completion: The completion handler to call when the image loading is complete.
    func loadImageFrom(link: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let url = URL.init(fileURLWithPath: link)
        let data = try? Data(contentsOf: url)
        let img = UIImage(data: data!)
        completion(img)
    }
    
    
    /// Sends order to the server.
    ///
    /// - Parameters:
    ///   - orderData:  Formatted data for order.
    ///   - completion: The completion handler to call when the image loading is complete.
    func sendOrder(orderData: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
        
        completion(nil)
    }

}
