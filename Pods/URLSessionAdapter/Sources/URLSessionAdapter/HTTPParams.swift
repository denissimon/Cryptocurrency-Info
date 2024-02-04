//
//  HTTPParams.swift
//  https://github.com/denissimon/URLSessionAdapter
//
//  Created by Denis Simon on 19/12/2020.
//
//  MIT License (https://github.com/denissimon/URLSessionAdapter/blob/main/LICENSE)
//

import Foundation

/// httpBody can be accepted as Data or Encodable
public struct HTTPParams {
    let httpBody: Any?
    let cachePolicy: URLRequest.CachePolicy?
    let timeoutInterval: TimeInterval?
    let headerValues: [(value: String, forHTTPHeaderField: String)]?
    
    public init(httpBody: Any?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, headerValues: [(value: String, forHTTPHeaderField: String)]?) {
        self.httpBody = httpBody
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.headerValues = headerValues
    }
}
