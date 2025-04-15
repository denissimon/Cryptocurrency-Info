//
//  Supportive.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import Foundation

class Supportive {
    
    static func getPriceStr(_ price: Decimal, currency: PriceCurrency) -> String {        
        let separator = [.AUD, .CAD, .CLP, .CNH, .CNY, .GBP, .HKD, .IDR, .JPY, .KRW, .MXN, .MYR, .NZD, .PHP, .SGD, .THB, .TRY, .TWD, .USD].contains(currency) ? "" : " "
        let currecnyArr: [PriceCurrency] = [.ARS, .AUD, .BRL, .CAD, .CHF, .CLP, .CNH, .CNY, .COP, .GBP, .HKD, .IDR, .ILS, .INR, .JPY, .KRW, .MXN, .MYR, .NZD, .PEN, .PHP, .SGD, .THB, .TRY, .TWD, .ZAR, .USD]
        
        if currecnyArr.contains(currency) {
            return currency.symbol + separator + String(format: price < 1.0 ? "%.4f" : "%.2f", Double(price.description) ?? Double.zero)
        } else {
            return String(format: price < 1.0 ? "%.4f" : "%.2f", Double(price.description) ?? Double.zero) + " " + currency.symbol
        }
    }
}
