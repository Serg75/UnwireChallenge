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
    
    var description: String {
        switch self {
        case .OK:
            return "OK"
        case .BadRequest:
            return "Bad Request"
        case .InternalServerError:
            return "Internal Server Error"
        }
    }
}

enum ParsingError: Error {
    case missing(String)
    case invalid(String, Any)
}

enum FileError: Error {
    case missing(String)
    case invalid(String)
}
