//
//  DefaultSettingsRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

class DefaultSettingsRepository: SettingsRepository {
    
    private let settingsDBInteractor: SettingsDBInteractor
    
    init(settingsDBInteractor: SettingsDBInteractor) {
        self.settingsDBInteractor = settingsDBInteractor
    }
    
    // MARK: - DB methods
    
    func getSelectedCurrency() async -> Currency? {
        await settingsDBInteractor.getSelectedCurrency()
    }
    
    func saveSelectedCurrency(_ currency: Currency) async -> Bool {
        await settingsDBInteractor.saveSelectedCurrency(currency)
    }
}
