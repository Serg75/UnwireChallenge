//
//  Codes.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import Foundation


enum ResponseStatus: Int {
    case OK = 200
    case BadRequest = 400
    case InternalServerError = 500
}

enum ParsingError: Error {
    case missing(String)
    case invalid(String, Any)
}
