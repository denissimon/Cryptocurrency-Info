//
//  Helpers.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import Foundation

class Helpers {
    
    static func getPriceStr(_ price: Double, currency: PriceCurrency) -> String {
        if price < 1.0 {
            return currency.rawValue + String(format: "%.4f", price)
        } else {
            return currency.rawValue + String(format: "%.2f", price)
        }
    }
}
