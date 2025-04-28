//
//  SettingsDBInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

protocol SettingsDBInteractor {
    func getSelectedCurrency() async -> Currency? where Currency: Codable
    func saveSelectedCurrency(_ currency: Currency) async -> Bool where Currency: Codable
}
