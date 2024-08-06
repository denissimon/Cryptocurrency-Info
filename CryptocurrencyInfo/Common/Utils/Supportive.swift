//
//  Supportive.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import Foundation

class Supportive {
    
    static func getPriceStr(_ price: Double, currency: PriceCurrency) -> String {
        
        let separator = currency.rawValue.count == 1 ? "" : " "
        
        if price < 1.0 {
            return currency.rawValue + separator + String(format: "%.4f", price)
        } else {
            return currency.rawValue + separator +  String(format: "%.2f", price)
        }
    }
}
