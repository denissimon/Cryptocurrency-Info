//
//  DefaultSettingsRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

class DefaultSettingsRepository: SettingsRepository {
    
    let settingsDBInteractor: SettingsDBInteractor
    
    init(settingsDBInteractor: SettingsDBInteractor) {
        self.settingsDBInteractor = settingsDBInteractor
    }
    
    // MARK: - DB methods
    
    func saveSelectedCurrency(_ currency: Currency) async -> Bool? {
        await withCheckedContinuation { continuation in
            let result = settingsDBInteractor.saveSelectedCurrency(currency, type: Currency.self)
            continuation.resume(returning: result)
        }
    }
    
    func getSelectedCurrency() async -> Currency? {
        await withCheckedContinuation { continuation in
            let result = settingsDBInteractor.getSelectedCurrency(type: Currency.self)
            continuation.resume(returning: result)
        }
    }
}
