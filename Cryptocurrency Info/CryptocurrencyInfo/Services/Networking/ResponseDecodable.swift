//
//  ResponseDecodable.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// This file is a part of reusable and universal networking layer based on URLSession and Codable (originally introduced in https://github.com/denissimon/ImageSearch)

import Foundation

struct ResponseDecodable {
    
    fileprivate var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            return response
        } catch _ {
            return nil
        }
    }
}
