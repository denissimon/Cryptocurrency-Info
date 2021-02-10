//
//  RequestFactory.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// This file is a part of reusable and universal networking layer based on URLSession and Codable (originally introduced in https://github.com/denissimon/ImageSearch)

import Foundation

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

class RequestFactory {
    
    static func request(url: URL, method: Method, params: HTTPParams? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let params = params {
            if params.httpBody != nil { request.httpBody = params.httpBody! }
            if params.cachePolicy != nil { request.cachePolicy = params.cachePolicy! }
            if params.timeoutInterval != nil { request.timeoutInterval = params.timeoutInterval! }
            if params.headerValues != nil {
                for header in params.headerValues! {
                    request.addValue(header.value, forHTTPHeaderField: header.forHTTPHeaderField)
                }
            }
        }
        
        return request
    }
}
