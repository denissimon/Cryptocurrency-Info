//
//  SettingsDBInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

import Foundation

protocol SettingsDBInteractor {
    func saveSelectedCurrency<T: Codable>(_ currency: T, type: T.Type) -> Bool?
    func getSelectedCurrency<T: Codable>(type: T.Type) -> T?
}
