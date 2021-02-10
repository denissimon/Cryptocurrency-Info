//
//  EndpointType.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// This file is a part of reusable and universal networking layer based on URLSession and Codable (originally introduced in https://github.com/denissimon/ImageSearch)

import Foundation

protocol EndpointType {
    var method: Method { get }
    var path: String { get }
    var baseURL: String { get }
    var constructedURL: URL? { get }
}
