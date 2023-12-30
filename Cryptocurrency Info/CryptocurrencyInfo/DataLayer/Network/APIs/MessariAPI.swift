//
//  MessariAPI.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// https://messari.io/api/docs

import Foundation

struct MessariAPI {
    
    static let baseURL = AppConfiguration.ProductionServer.messariBaseURL
    
    static let defaultParams = HTTPParams(httpBody: nil, cachePolicy: nil, timeoutInterval: 10.0, headerValues:[
        (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue),
        (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue),
        (value: AppConfiguration.ProductionServer.messariApiKey, forHTTPHeaderField: HTTPHeaderField.xMessariApiKey.rawValue)])
    
    static func assets(page: Int) -> EndpointType {
        let path = "/v2/assets?page=\(page)&limit=\(AppConfiguration.ProductionServer.limitOnPage)&with-metrics&fields=id,name,symbol,metrics/market_data/price_usd"
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
    
    static func profile(asset: String) -> EndpointType {
        let path = "/v2/assets/\(asset)/profile?fields=profile/general/overview/tagline,profile/general/overview/project_details,profile/general/overview/official_links"
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
    
    static func timeSeries(data: TimeSeriesInputData) -> EndpointType {
        let path = "/v1/assets/\(data.asset)/metrics/price/time-series?after=\(data.date())&interval=\(data.interval.rawValue)&columns=timestamp,close" // as an option: columns=timestamp,open,close (this will require to change 'value[1]' to 'value[2]' in setChartData() in DetailsDataSource.swift)
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
    
    static func price(asset: String) -> EndpointType {
        let path = "/v1/assets/\(asset)/metrics/market-data"
        
        let params = MessariAPI.defaultParams
        
        return Endpoint(
            method: .GET,
            baseURL: MessariAPI.baseURL,
            path: path,
            params: params)
    }
}
