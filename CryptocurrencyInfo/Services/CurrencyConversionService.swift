//
//  CurrencyConversionService.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

protocol CurrencyConversionService {
    func convertCurrency(_ assets: inout [Asset]) async
    func convertCurrency(_ asset: inout Asset) async
}

class DefaultCurrencyConversionService: CurrencyConversionService {
    
    let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    func convertCurrency(_ assets: inout [Asset]) async {
        guard AppConfiguration.Settings.selectedCurrency != .USD else { return }
        
        // TODO: Convert the price of each asset to the selected currency using CurrencyConversionAPI
        try? await Task.sleep(nanoseconds: 1 * 5_000_000) // mock the API request
        let rate: Decimal = 1.1 // mock the received rate
        
        for asset in assets {
            asset.price.amount = asset.priceUsd * rate
            
            if asset.price.currency != AppConfiguration.Settings.selectedCurrency {
                asset.price.currency = AppConfiguration.Settings.selectedCurrency
            }
        }
    }
    
    func convertCurrency(_ asset: inout Asset) async {
        guard AppConfiguration.Settings.selectedCurrency != .USD else { return }
        
        // TODO: Convert the price of an asset to the selected currency using CurrencyConversionAPI
        try? await Task.sleep(nanoseconds: 1 * 5_000_000) // mock the API request
        let rate: Decimal = 1.1 // mock the received rate
        asset.price.amount = asset.priceUsd * rate
        
        if asset.price.currency != AppConfiguration.Settings.selectedCurrency {
            asset.price.currency = AppConfiguration.Settings.selectedCurrency
        }
    }
}
