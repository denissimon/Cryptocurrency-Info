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
    
    func saveSelectedCurrency<T: Codable>(_ currency: T, type: T.Type) -> Bool? {
        if let encodedData = try? JSONEncoder().encode(currency), let jsonString = String(data: encodedData, encoding: .utf8) {
            userDefaultsAdapter.set(value: jsonString, forKey: selectedCurrencyKey)
            return true
        } else {
            return nil
        }
    }
    
    func getSelectedCurrency<T: Codable>(type: T.Type) -> T? {
        guard let json = userDefaultsAdapter.get(forKey: selectedCurrencyKey) else { return nil }
        if let jsonData = json.data(using: .utf8), let decoded = try? JSONDecoder().decode(type, from: jsonData) {
            return decoded
        } else {
            return nil
        }
    }
}
