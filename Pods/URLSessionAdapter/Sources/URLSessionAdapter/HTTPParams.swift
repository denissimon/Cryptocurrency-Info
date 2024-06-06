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
public class HTTPParams {
    public var httpBody: Any?
    public var cachePolicy: URLRequest.CachePolicy?
    public var timeoutInterval: TimeInterval?
    public var headerValues: [(value: String, forHTTPHeaderField: String)]?
    
    public init(httpBody: Any? = nil, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, headerValues: [(value: String, forHTTPHeaderField: String)]? = nil) {
        self.httpBody = httpBody
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.headerValues = headerValues
    }
}

public enum HTTPHeader: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case accept = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case connection = "Connection"
}

public enum ContentType: String {
    case applicationJson = "application/json"
    case applicationFormUrlencoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
    case textPlain = "text/plain"
    case applicationXML = "application/xml"
    case applicationQuery = "application/query"
}
