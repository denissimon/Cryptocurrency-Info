//
//  Asset.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import Foundation

class Asset: Codable {
    /// E.g. "BTC"
    let symbol: String
    /// E.g. "Bitcoin"
    let name: String
    /// Asset price in USD
    var priceUsd: Decimal
    /// Preparing data for display based on priceUsd and AppConfiguration.Settings.selectedCurrency (assumed to be user changeable). This includes converting from USD to another currency available for selection.
    var price: Money
    
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
    
    init(symbol: String, name: String, priceUsd: Decimal, price: Money) {
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
        self.price = price
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decode(String.self, forKey: .symbol)
        name = try values.decode(String.self, forKey: .name)
        
        let metrics = try values.nestedContainer(keyedBy: MetricsKeys.self, forKey: .metrics)
        let marketData = try metrics.nestedContainer(keyedBy: MetricsKeys.MarketDataKeys.self, forKey: .marketData)
        priceUsd = try marketData.decode(Decimal.self, forKey: .priceUsd)
        price = Money(amount: priceUsd, currency: .USD)
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
