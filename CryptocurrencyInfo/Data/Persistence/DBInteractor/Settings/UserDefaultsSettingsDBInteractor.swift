//
//  UserDefaultsSettingsDBInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

class UserDefaultsSettingsDBInteractor: SettingsDBInteractor {
    
    let userDefaultsAdapter: UserDefaultsAdapter
    
    let selectedCurrencyKey = "selected_currency"
    
    init(with userDefaultsAdapter: UserDefaultsAdapter) {
        self.userDefaultsAdapter = userDefaultsAdapter
    }
    
    func getSelectedCurrency() -> Currency? {
        guard let json = userDefaultsAdapter.get(forKey: selectedCurrencyKey) else { return nil }
        if let jsonData = json.data(using: .utf8), let decoded = try? JSONDecoder().decode(Currency.self, from: jsonData) {
            return decoded
        } else {
            return nil
        }
    }
    
    func saveSelectedCurrency(_ currency: Currency) -> Bool {
        if let encodedData = try? JSONEncoder().encode(currency), let jsonString = String(data: encodedData, encoding: .utf8) {
            userDefaultsAdapter.set(value: jsonString, forKey: selectedCurrencyKey)
            return true
        } else {
            return false
        }
    }
}
