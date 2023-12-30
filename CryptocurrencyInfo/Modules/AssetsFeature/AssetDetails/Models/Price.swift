//
//  Price.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 25.12.2020.
//

struct Price: Codable {
    let data: PriceDataClass
}

struct PriceDataClass: Codable {
    let marketData: PriceMarketData

    enum CodingKeys: String, CodingKey {
        case marketData = "market_data"
    }
}

struct PriceMarketData: Codable {
    let priceUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case priceUsd = "price_usd"
    }
}
