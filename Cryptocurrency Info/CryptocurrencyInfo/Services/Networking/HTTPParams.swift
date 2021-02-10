//
//  HTTPParams.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// This file is a part of reusable and universal networking layer based on URLSession and Codable (originally introduced in https://github.com/denissimon/ImageSearch)

import Foundation

struct HTTPParams {
    // The data sent as the message body of a request, such as for an HTTP POST request.
    let httpBody: Data?
    
    // The request’s cache policy.
    let cachePolicy: URLRequest.CachePolicy?
    
    // The timeout interval of the request.
    let timeoutInterval: TimeInterval?
    
    // For adding values to the request headers.
    let headerValues: [(value: String, forHTTPHeaderField: String)]?
}
