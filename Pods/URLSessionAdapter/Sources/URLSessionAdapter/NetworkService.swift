//
//  NetworkService.swift
//  https://github.com/denissimon/URLSessionAdapter
//
//  Created by Denis Simon on 19/12/2020.
//
//  MIT License (https://github.com/denissimon/URLSessionAdapter/blob/main/LICENSE)
//

import Foundation

public struct NetworkError: Error {
    public let error: Error?
    public let statusCode: Int?
    public let data: Data?
    
    public init(error: Error?, statusCode: Int?, data: Data?) {
        self.error = error
        self.statusCode = statusCode
        self.data = data
    }
}

protocol NetworkServiceType {
    var urlSession: URLSession { get }
    func request(_ endpoint: EndpointType, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable?
    func request<T: Decodable>(_ endpoint: EndpointType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkCancellable?
    func fetchFile(url: URL, completion: @escaping (Data?) -> Void) -> NetworkCancellable?
}

open class NetworkService: NetworkServiceType {
       
    public private(set) var urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func request(_ endpoint: EndpointType, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable? {
        
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            completion(.failure(NetworkError(error: nil, statusCode: nil, data: nil)))
            return nil
        }
        
        let request = RequestFactory.request(url: url, method: endpoint.method, params: endpoint.params)
        log("\nNetworkService request \(endpoint.method.rawValue), url: \(url)")
        
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if error == nil {
                completion(.success(data))
                return
            }
            let response = response as? HTTPURLResponse
            let statusCode = response?.statusCode
            completion(.failure(NetworkError(error: error, statusCode: statusCode, data: data)))
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    public func request<T: Decodable>(_ endpoint: EndpointType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkCancellable? {
        
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            completion(.failure(NetworkError(error: nil, statusCode: nil, data: nil)))
            return nil
        }
        
        let request = RequestFactory.request(url: url, method: endpoint.method, params: endpoint.params)
        log("\nNetworkService request<T: Decodable> \(endpoint.method.rawValue), url: \(url)")
        
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            let response = response as? HTTPURLResponse
            let statusCode = response?.statusCode
            
            if error == nil {
                guard let data = data, let decoded = ResponseDecodable.decode(type, data: data) else {
                    completion(.failure(NetworkError(error: nil, statusCode: statusCode, data: data)))
                    return
                }
                completion(.success(decoded))
                return
            }
            
            completion(.failure(NetworkError(error: error, statusCode: statusCode, data: data)))
        }

        dataTask.resume()
        
        return dataTask
    }
    
    public func fetchFile(url: URL, completion: @escaping (Data?) -> Void) -> NetworkCancellable? {
        let request = RequestFactory.request(url: url, method: .GET, params: nil)
        log("\nNetworkService fetchFile: \(url)")
     
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if data != nil && error == nil {
                completion(data!)
                return
            }
            return completion(nil)
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func log(_ str: String) {
        #if DEBUG
        print(str)
        #endif
    }
}

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionDataTask: NetworkCancellable {}
