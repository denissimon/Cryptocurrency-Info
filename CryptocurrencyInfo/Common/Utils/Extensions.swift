//
//  Extensions.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 26.12.2020.
//

import Foundation

// https://gist.github.com/denissimon/3271d125cc0705dc46881e8f741d6775

extension Decimal {
    mutating func round(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) {
        var localCopy = self
        NSDecimalRound(&self, &localCopy, scale, roundingMode)
    }

    func rounded(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, roundingMode)
        return result
    }
}

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: AppConfiguration.Settings.selectedCurrency.local)
        return formatter
    }
}
