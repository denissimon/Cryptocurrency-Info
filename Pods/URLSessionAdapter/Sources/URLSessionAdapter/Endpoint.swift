//
//  Endpoint.swift
//  https://github.com/denissimon/URLSessionAdapter
//
//  Created by Denis Simon on 19/12/2020.
//
//  MIT License (https://github.com/denissimon/URLSessionAdapter/blob/main/LICENSE)
//

import Foundation

public protocol EndpointType {
    var method: HTTPMethod { get }
    var path: String { get }
    var baseURL: String { get }
    var params: HTTPParams? { get set }
}

public class Endpoint: EndpointType {
    public let method: HTTPMethod
    public let baseURL: String
    public let path: String
    public var params: HTTPParams?
    
    public init(method: HTTPMethod, baseURL: String, path: String, params: HTTPParams?) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.params = params
    }
}
