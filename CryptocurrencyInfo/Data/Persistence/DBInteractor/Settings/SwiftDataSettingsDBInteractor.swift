//
//  SwiftDataSettingsDBInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

import Foundation
import SwiftData

class SwiftDataSettingsDBInteractor: SettingsDBInteractor {
    
    let swiftDataAdapter: SwiftDataAdapter
    
    var settingsModel: SettingsModel?
    
    init(with swiftDataAdapter: SwiftDataAdapter) {
        self.swiftDataAdapter = swiftDataAdapter
        Task.detached {
            self.setup()
        }
    }
    
    private func setup() {
        let descriptor = FetchDescriptor<SettingsModel>()
        let count = swiftDataAdapter.fetchCount(SettingsModel.self, descriptor: descriptor)
        // Create a new row in the Settings table if there are no rows yet (this table should have only 1 row)
        if count == 0 {
            swiftDataAdapter.insert(SettingsModel(.USD))
        }
    }

    private func getSettingsModel() -> SettingsModel? {
        var descriptor = FetchDescriptor<SettingsModel>()
        descriptor.fetchLimit = 1
        let result = swiftDataAdapter.fetch(SettingsModel.self, descriptor: descriptor)
        
        switch result {
        case .success(let settingsModelArr):
            return settingsModelArr.first
        case .failure(_):
            return nil
        }
    }
    
    func getSelectedCurrency() -> Currency? {
        if settingsModel == nil {
            settingsModel = getSettingsModel()
        }
        return settingsModel?.selectedCurrency
    }
    
    func saveSelectedCurrency(_ currency: Currency) -> Bool {
        if settingsModel != nil {
            guard settingsModel!.selectedCurrency != currency else { return false }
            settingsModel!.selectedCurrency = currency
            if settingsModel!.hasChanges {
                try? settingsModel!.modelContext?.save()
                return true
            }
            return false
        }
        settingsModel = getSettingsModel()
        return false
    }
}
