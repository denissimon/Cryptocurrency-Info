//
//  MessariAPI.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

// https://messari.io/api/docs

import Foundation

enum MessariAPI {
    case assets(page: Int)
    case profile(asset: String)
    case timeSeries(data: TimeSeriesInputData)
    case price(asset: String)
}

extension MessariAPI: EndpointType {
    
    var method: Method {
        switch self {
        case .assets, .profile, .timeSeries, .price:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .assets(let page):
            return "/v2/assets?page=\(page)&limit=\(Constants.ProductionServer.limitOnPage)&with-metrics&fields=id,name,symbol,metrics/market_data/price_usd"
        case .profile(let asset):
            return "/v2/assets/\(asset)/profile?fields=profile/general/overview/tagline,profile/general/overview/project_details,profile/general/overview/official_links"
        case .timeSeries(let data):
            return "/v1/assets/\(data.asset)/metrics/price/time-series?after=\(data.date())&interval=\(data.interval.rawValue)&columns=timestamp,close" // as an option: columns=timestamp,open,close (this will require to change 'value[1]' to 'value[2]' in setChartData() in DetailsDataSource.swift)
        case .price(let asset):
            return "/v1/assets/\(asset)/metrics/market-data"
        }
    }
    
    var baseURL: String {
        return Constants.ProductionServer.baseURL
    }
    
    var constructedURL: URL? {
        switch self {
        case .assets(_), .profile(_), .timeSeries(_), .price(_):
            return URL(string: self.baseURL + self.path)
        }
    }
}

