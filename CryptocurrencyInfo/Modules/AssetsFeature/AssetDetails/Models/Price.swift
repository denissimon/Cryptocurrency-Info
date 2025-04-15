//
//  Price.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 25.12.2020.
//

import Foundation

struct Price: Codable {
    let priceUsd: Decimal
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum DataKeys: String, CodingKey {
        case marketData = "market_data"
        
        enum MarketDataKeys: String, CodingKey {
            case priceUsd = "price_usd"
        }
    }
    
    init(priceUsd: Decimal) {
        self.priceUsd = priceUsd
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let marketData = try data.nestedContainer(keyedBy: DataKeys.MarketDataKeys.self, forKey: .marketData)
        priceUsd = try marketData.decode(Decimal.self, forKey: .priceUsd)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        var marketData = data.nestedContainer(keyedBy: DataKeys.MarketDataKeys.self, forKey: .marketData)
        try marketData.encode(priceUsd, forKey: .priceUsd)
    }
}
