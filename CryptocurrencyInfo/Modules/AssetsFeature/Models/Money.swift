//
//  Money.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 12.04.2025.
//

import Foundation

struct Money: Codable, Hashable {
    
    var amount: Decimal
    var currency: Currency
    var formatedAmount: String {
        get {
            return NumberFormatter.currencyFormatter.string(from: amount as NSDecimalNumber)!
        }
    }
    
    init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
    
    init() {
        self.amount = Decimal.zero
        self.currency = .USD
    }
    
    mutating func addAndUpdate(plus: Money) {
        let adding = NSDecimalNumber(decimal: plus.amount)
        let current = NSDecimalNumber(decimal: amount)
        let updated = current.adding(adding)
        self.amount = updated.decimalValue
    }
    
    mutating func multiplyAndUpdate(factor: Money) {
        let multiplying = NSDecimalNumber(decimal: factor.amount)
        let current = NSDecimalNumber(decimal: amount)
        let updated = current.multiplying(by: multiplying)
        self.amount = updated.decimalValue
    }
}

extension Money {
    var formatedAmountCustomized: String {
        get {
            let separator = [.AUD, .CAD, .CLP, .CNH, .CNY, .GBP, .HKD, .IDR, .JPY, .KRW, .MXN, .MYR, .NZD, .PHP, .SGD, .THB, .TRY, .TWD, .USD].contains(currency) ? "" : " "
            let currecnyArr: [Currency] = [.ARS, .AUD, .BRL, .CAD, .CHF, .CLP, .CNH, .CNY, .COP, .GBP, .HKD, .IDR, .ILS, .INR, .JPY, .KRW, .MXN, .MYR, .NZD, .PEN, .PHP, .SGD, .THB, .TRY, .TWD, .ZAR, .USD]
            
            if currecnyArr.contains(currency) {
                return currency.symbol + separator + String(format: amount < 1.0 ? "%.4f" : "%.2f", Double(amount.description) ?? Double.zero)
            } else {
                return String(format: amount < 1.0 ? "%.4f" : "%.2f", Double(amount.description) ?? Double.zero) + " " + currency.symbol
            }
        }
    }
}
