//
//  UrlDataProvider.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation


class UrlDataProvider: DataProvider {
    
    let url = URL(string: "https://mock-shirt-backend.getsandbox.com/shirts")!

    func loadData(completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let loadDataTask = URLSession.shared.dataTask(with: url) { (data, response, innerError) in
            
            if let _ = innerError {
                
                completion(nil, innerError)
                
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
