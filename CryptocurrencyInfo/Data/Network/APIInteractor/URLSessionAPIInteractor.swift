//
//  URLSessionAPIInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

class URLSessionAPIInteractor: APIInteractor {
    
    private let urlSessionAdapter: NetworkService
    
    init(with networkService: NetworkService) {
        self.urlSessionAdapter = networkService
    }
    
    func request(_ endpoint: EndpointType, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable? {
        guard let request = RequestFactory.request(endpoint),
              let networkCancellable = urlSessionAdapter.request(request, completion: completion) else {
            completion(.failure(NetworkError()))
            return nil
        }
        return networkCancellable
    }
    
    func request<T: Decodable>(_ endpoint: EndpointType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkCancellable? {
        guard let request = RequestFactory.request(endpoint),
              let networkCancellable = urlSessionAdapter.request(request, type: type, completion: completion) else {
            completion(.failure(NetworkError()))
            return nil
        }
        return networkCancellable
    }
}


