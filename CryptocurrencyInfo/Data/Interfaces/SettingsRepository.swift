//
//  SettingsRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

protocol SettingsRepository {
    func getSelectedCurrency() async -> Currency?
    func saveSelectedCurrency(_ currency: Currency) async -> Bool
}
