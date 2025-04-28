//
//  SwiftDataAdapter.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

// https://gist.github.com/denissimon/fff3142561c6bbb0e3e8961681ec5e89

import Foundation
import SwiftData

actor SwiftDataAdapter: ModelActor {
    
    nonisolated let modelContainer: ModelContainer
    nonisolated let modelExecutor: any ModelExecutor
    
    private var context: ModelContext
    
    init(modelContainer: ModelContainer, autosaveEnabled: Bool = true) {
        context = ModelContext(modelContainer)
        context.autosaveEnabled = autosaveEnabled
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        self.modelContainer = modelContainer
        print(context.sqliteUrlPath)
    }
    
    /// Insert an object
    func insert<T: PersistentModel>(_ object: T) throws {
        context.insert(object)
        try context.save()
    }
    
    /// Fetch one or several objects using a descriptor
    func fetch<T: PersistentModel>(_ type: T.Type, descriptor: FetchDescriptor<T>) throws -> [T] {
        return try context.fetch(descriptor)
    }
    
    /// Delete an object
    func delete<T: PersistentModel>(_ object: T) throws {
        context.delete(object)
        try context.save()
    }
    
    /// Delete one or several objects using a predicate.
    /// If you don’t provide a predicate, the context will remove all objects of the specified type.
    func delete<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>? = nil) throws {
        try context.delete(model: type, where: predicate)
        try context.save()
    }
    
    /// Delete all objects
    func deleteAll() throws {
        context.container.deleteAllData() // erase() from iOS 18
        try context.save()
    }
    
    /// Get the number of objects using a descriptor
    func fetchCount<T: PersistentModel>(_ type: T.Type, descriptor: FetchDescriptor<T>) -> Int {
        let count = (try? context.fetchCount(descriptor)) ?? 0
        return count
    }
}

extension ModelContext {
    var sqliteUrlPath: String {
        if let urlPath = container.configurations.first?.url.path(percentEncoded: false) {
            "SQLite: \(urlPath)"
        } else {
            "No SQLite database found."
        }
    }
}
