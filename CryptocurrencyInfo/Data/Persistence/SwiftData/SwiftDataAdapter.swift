//
//  SwiftDataAdapter.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

// https://gist.github.com/denissimon/fff3142561c6bbb0e3e8961681ec5e89

import Foundation
import SwiftData

actor SwiftDataAdapter {
    
    private let container: ModelContainer
    private var context: ModelContext!
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    /// Since ModelContexts are not Sendable, this context should be instantiated on the queue from which it is used, not the main.
    private func createContext(autosaveEnabled: Bool = true) -> ModelContext {
        let context = ModelContext(container)
        context.autosaveEnabled = autosaveEnabled
        self.context = context
        print(context.sqliteUrlPath)
        return context
    }
    
    /// Insert an object
    func insert<T: PersistentModel>(_ object: T) throws {
        if context == nil { context = createContext() }
        context.insert(object)
        try context.save()
    }
    
    /// Fetch one or several objects using a descriptor
    func fetch<T: PersistentModel>(_ type: T.Type, descriptor: FetchDescriptor<T>) throws -> [T] {
        if context == nil { context = createContext() }
        return try context.fetch(descriptor)
    }
    
    /// Delete an object
    func delete<T: PersistentModel>(_ object: T) throws {
        if context == nil { context = createContext() }
        context.delete(object)
        try context.save()
    }
    
    /// Delete one or several objects using a predicate.
    /// If you don’t provide a predicate, the context will remove all objects of the specified type.
    func delete<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>? = nil) throws {
        if context == nil { context = createContext() }
        try context.delete(model: type, where: predicate)
        try context.save()
    }
    
    /// Delete all objects
    func deleteAll() throws {
        if context == nil { context = createContext() }
        context.container.deleteAllData() // erase() from iOS 18
        try context.save()
    }
    
    /// Get the number of objects using a descriptor
    func fetchCount<T: PersistentModel>(_ type: T.Type, descriptor: FetchDescriptor<T>) -> Int {
        if context == nil { context = createContext() }
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
