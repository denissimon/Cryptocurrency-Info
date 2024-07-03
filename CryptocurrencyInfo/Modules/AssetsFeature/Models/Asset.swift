//
//  Asset.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

struct Asset: Codable {
    let symbol: String
    let name: String
    var priceUsd: Double?
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case metrics
    }
    
    enum MetricsKeys: String, CodingKey {
        case marketData = "market_data"
        
        enum MarketDataKeys: String, CodingKey {
            case priceUsd = "price_usd"
        }
    }
    
    init(symbol: String, name: String, priceUsd: Double) {
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decode(String.self, forKey: .symbol)
        name = try values.decode(String.self, forKey: .name)
        
        let metrics = try values.nestedContainer(keyedBy: MetricsKeys.self, forKey: .metrics)
        let marketData = try metrics.nestedContainer(keyedBy: MetricsKeys.MarketDataKeys.self, forKey: .marketData)
        priceUsd = try? marketData.decode(Double.self, forKey: .priceUsd)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(name, forKey: .name)
        
        var metrics = container.nestedContainer(keyedBy: MetricsKeys.self, forKey: .metrics)
        var marketData = metrics.nestedContainer(keyedBy: MetricsKeys.MarketDataKeys.self, forKey: .marketData)
        try marketData.encode(priceUsd, forKey: .priceUsd)
    }
}
