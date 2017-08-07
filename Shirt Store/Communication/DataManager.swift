//
//  DataManager.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation

let url = "https://mock-shirt-backend.getsandbox.com"

public class DataManager {
    
    public class func getShirtsWithSuccess(success: @escaping ((_ data: Data) -> Void), error: @escaping ((_ error: Error) -> Void)) {
        loadDataFromURL(url: URL(string: url + "/shirts")!) { (data, innerError) -> Void in
            if let data = data {
                success(data)
            } else {
                error(innerError!)
            }
        }
    }
    
    public class func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {

        let loadDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            if let _ = error {

                completion(nil, error)
            
            } else if let response = response as? HTTPURLResponse {

                if response.statusCode == ResponseStatus.OK.rawValue {

                    completion(data, nil)
                    
                } else {
                    
                    var statusDescription = "HTTP status code has unexpected value."
                    if let status = ResponseStatus(rawValue: response.statusCode) {
                        statusDescription += " (\(status))"
                    }
                    
                    let statusError = NSError(domain: "com.unwire",
                                              code: response.statusCode,
                                              userInfo: [NSLocalizedDescriptionKey: statusDescription])
                    completion(nil, statusError)
                }
            }
        }
        loadDataTask.resume()
    }
}
