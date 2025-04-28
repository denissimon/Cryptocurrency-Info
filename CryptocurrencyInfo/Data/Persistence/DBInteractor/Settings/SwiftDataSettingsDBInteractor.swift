//
//  SwiftDataSettingsDBInteractor.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

import Foundation
import SwiftData

class SwiftDataSettingsDBInteractor: SettingsDBInteractor {
    
    private let swiftDataAdapter: SwiftDataAdapter
    
    private var settingsModel: SettingsModel?
    
    init(with swiftDataAdapter: SwiftDataAdapter) {
        self.swiftDataAdapter = swiftDataAdapter
        Task.detached {
            await self.setup()
        }
    }
    
    private func log(_ error: SwiftDataError) {
        // Optionally, reporting solutions like Firebase Crashlytics can be used here
        #if DEBUG
        print("SwiftData:", error)
        #endif
    }
    
    private func setup() async {
        let descriptor = FetchDescriptor<SettingsModel>()
        let settingsRowCount = await swiftDataAdapter.fetchCount(SettingsModel.self, descriptor: descriptor)
        // Create a new row in the SettingsModel table if there are no rows yet (it should have only 1 row)
        if settingsRowCount == 0 {
            do {
                try await swiftDataAdapter.insert(SettingsModel(.USD))
            } catch {
                log(error as! SwiftDataError)
            }
        }
    }

    private func getSettingsModel() async -> SettingsModel? {
        var descriptor = FetchDescriptor<SettingsModel>()
        descriptor.fetchLimit = 1
        do {
            let settingsModelArr = try await swiftDataAdapter.fetch(SettingsModel.self, descriptor: descriptor)
            return settingsModelArr.first
        } catch {
            log(error as! SwiftDataError)
            return nil
        }
    }
    
    func getSelectedCurrency() async -> Currency? {
        if settingsModel == nil {
            settingsModel = await getSettingsModel()
        }
        return settingsModel?.selectedCurrency
    }
    
    func saveSelectedCurrency(_ currency: Currency) async -> Bool {
        guard settingsModel != nil else {
            settingsModel = await getSettingsModel()
            return false
        }
        guard settingsModel!.selectedCurrency != currency else { return false }
        settingsModel!.selectedCurrency = currency
        if settingsModel!.hasChanges {
            do {
                try settingsModel!.modelContext?.save()
                return true
            } catch {
                log(error as! SwiftDataError)
            }
        }
        return false
    }
}
