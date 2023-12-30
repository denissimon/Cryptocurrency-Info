//
//  Asset.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

struct Asset: Codable {
    let symbol: String
    let name: String
    var metrics: Metrics
}

struct Metrics: Codable {
    var marketData: MarketData

    enum CodingKeys: String, CodingKey {
        case marketData = "market_data"
    }
}

struct MarketData: Codable {
    var priceUsd: Double?

    enum CodingKeys: String, CodingKey {
        case priceUsd = "price_usd"
    }
}
