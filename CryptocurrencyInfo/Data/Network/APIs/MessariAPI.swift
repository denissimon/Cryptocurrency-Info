//
//  MessariAPI.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// https://messari.io/api/docs

import Foundation
import URLSessionAdapter

struct MessariAPI {
    
    static let baseURL = AppConfiguration.ProductionServer.messariBaseURL
    
    static let defaultParams = HTTPParams(httpBody: nil, cachePolicy: nil, timeoutInterval: 10.0, headerValues:[
        (value: ContentType.applicationJson.rawValue, forHTTPHeaderField: HTTPHeader.accept.rawValue),
        (value: ContentType.applicationJson.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue),
        (value: AppConfiguration.ProductionServer.messariApiKey, forHTTPHeaderField: "x-messari-api-key")])
    
    static func assets(page: Int) -> EndpointType {
        let path = "/v2/assets?page=\(page)&limit=\(AppConfiguration.ProductionServer.limitOnPage)&with-metrics/market_data/price_usd"
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
    
    static func profile(symbol: String) -> EndpointType {
        let path = "/v2/assets/\(symbol)/profile?fields=profile/general/overview/tagline,profile/general/overview/project_details,profile/general/overview/official_links"
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
    
    static func price(symbol: String) -> EndpointType {
        let path = "/v1/assets/\(symbol)/metrics/market-data"
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
}
