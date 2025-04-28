//
//  SwiftDataConfiguration.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

import SwiftData

struct SwiftDataConfiguration {
    
    private static let schema = Schema([
        SettingsModel.self,
    ])
    
    static let container: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    /// For unit tests
    static let containerInMemoryOnly: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
