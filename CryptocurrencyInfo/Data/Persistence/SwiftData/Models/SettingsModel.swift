//
//  SettingsModel.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

import SwiftData

@Model
class SettingsModel {
        
    var selectedCurrency: Currency
    
    init(_ selectedCurrency: Currency) {
        self.selectedCurrency = selectedCurrency
    }
}
