//
//  APIInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation

protocol APIInteractor {
    @discardableResult
    func requestEndpoint(_ endpoint: EndpointType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> Cancellable?
    
    @discardableResult
    func requestEndpoint<T: Decodable>(_ endpoint: EndpointType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> Cancellable?
}
