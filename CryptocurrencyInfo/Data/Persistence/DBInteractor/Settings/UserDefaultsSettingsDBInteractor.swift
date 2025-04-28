//
//  UserDefaultsSettingsDBInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

class UserDefaultsSettingsDBInteractor: SettingsDBInteractor {
    
    private let userDefaultsAdapter: UserDefaultsAdapter
    
    init(with userDefaultsAdapter: UserDefaultsAdapter) {
        self.userDefaultsAdapter = userDefaultsAdapter
    }
    
    func getSelectedCurrency() -> Currency? {
        guard let json = userDefaultsAdapter.get(forKey: UserDefaultsKeys.selectedCurrency) else { return nil }
        if let jsonData = json.data(using: .utf8), let decoded = try? JSONDecoder().decode(Currency.self, from: jsonData) {
            return decoded
        } else {
            return nil
        }
    }
    
    func saveSelectedCurrency(_ currency: Currency) -> Bool {
        if let encodedData = try? JSONEncoder().encode(currency), let jsonString = String(data: encodedData, encoding: .utf8) {
            userDefaultsAdapter.set(value: jsonString, forKey: UserDefaultsKeys.selectedCurrency)
            return true
        } else {
            return false
        }
    }
}
