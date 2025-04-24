//
//  SwiftDataConfiguration.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

import SwiftData

struct SwiftDataConfiguration {
    
    static let container: ModelContainer = {
        let schema = Schema([
            SettingsModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static var context: ModelContext {
        let context = ModelContext(container)
        context.autosaveEnabled = true
        return context
    }
}
