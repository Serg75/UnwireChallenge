//
//  UrlDataProvider.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit


/// Class for getting/sending data from/to the default resources.
class UrlDataProvider: DataProvider {
    
    let url = URL(string: "https://mock-shirt-backend.getsandbox.com/shirts")!
    
    var imageCache = [String: UIImage]()
    

    /// Loads shirts list from the server.
    ///
    /// - Parameter completion: The completion handler to call when the image loading is complete.
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
    
    
    /// Retrieves an image from specified internet resource.
    ///
    /// - Parameters:
    ///   - link:       Link to the image.
    ///   - completion: The completion handler to call when the image loading is complete.
    func loadImageFrom(link: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let cachedImage = imageCache[link] {
            completion(cachedImage)
            return
        }
        
        if let url = URL(string: link) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                self.imageCache[link] = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    completion(self.imageCache[link])
                }
            }
        }
    }
}
