//
//  URLSessionAPIInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation

class URLSessionAPIInteractor: APIInteractor {
    
    let urlSessionAdapter: NetworkService
    
    init(with networkService: NetworkService) {
        self.urlSessionAdapter = networkService
    }
    
    func requestEndpoint(_ endpoint: EndpointType, completion: @escaping (Result<Data, NetworkError>) -> Void) -> Cancellable? {
        let networkTask = RepositoryTask()
        networkTask.networkTask = urlSessionAdapter.requestEndpoint(endpoint, completion: completion)
        return networkTask
    }
    
    func requestEndpoint<T: Decodable>(_ endpoint: EndpointType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> Cancellable? {
        let networkTask = RepositoryTask()
        networkTask.networkTask = urlSessionAdapter.requestEndpoint(endpoint, type: type, completion: completion)
        return networkTask
    }
}
