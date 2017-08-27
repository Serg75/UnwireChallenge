//
//  DataProvider.swift
//  Shirt Store
//
//  Created by Sergey S. on 26/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

/// Interface for data provider.
protocol DataProvider {

    /// Loads shirts list from the server.
    ///
    /// - Parameter completion: The completion handler to call when the image loading is complete.
    func loadData(completion: @escaping (_ data: Data?, _ error: Error?) -> Void)

    /// Retrieves an image from specified resource.
    ///
    /// - Parameters:
    ///   - link:       Link to the image.
    ///   - completion: The completion handler to call when the image loading is complete.
    func loadImageFrom(link: String, completion: @escaping (_ image: UIImage?) -> Void)

    /// Sends order to the server.
    ///
    /// - Parameters:
    ///   - orderData:  Formatted data for order.
    ///   - completion: The completion handler to call when the image loading is complete.
    func sendOrder(orderData: [String: Any], completion: @escaping (_ error: Error?) -> Void)
}
