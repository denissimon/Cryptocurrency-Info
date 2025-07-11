//
//  APIInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

protocol APIInteractor {
    @discardableResult
    func request(_ endpoint: EndpointType, completion: @escaping (Result<(data: Data?, response: URLResponse?), NetworkError>) -> Void) -> NetworkCancellable?
    
    @discardableResult
    func request<T: Decodable>(_ endpoint: EndpointType, type: T.Type, completion: @escaping (Result<(decoded: T, response: URLResponse?), NetworkError>) -> Void) -> NetworkCancellable?
}
