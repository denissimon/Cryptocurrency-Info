//
//  PriceRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import URLSessionAdapter

protocol PriceRepository {
    typealias PriceResult = Result<Price, NetworkError>
    
    func getPrice(asset: String) async -> PriceResult
}
