//
//  PriceRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import URLSessionAdapter

protocol PriceRepository {    
    func getPrice(symbol: String) async -> Result<Price, NetworkError>
}
