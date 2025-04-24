//
//  SwiftDataAdapter.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.04.2025.
//

// https://gist.github.com/denissimon/cf4beee8291843e7fced6b6292b3ef62

import Foundation
import SwiftData

struct SwiftDataError: Error {
    let error: Error?
    let description: String = ""
}

class SwiftDataAdapter {
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        print(context.sqliteUrlPath)
    }
    
    /// Insert an object
    func insert<T>(_ object: T) where T: PersistentModel {
        context.insert(object)
        try? context.save()
    }
    
    /// Fetch one or several objects using a descriptor
    func fetch<T>(_ type: T.Type, descriptor: FetchDescriptor<T>) -> Result<[T], SwiftDataError> where T: PersistentModel {
        do {
            let data = try context.fetch(descriptor)
            return .success(data)
        } catch (let error) {
            return .failure(SwiftDataError(error: error))
        }
    }
    
    /// Delete an object
    func delete<T>(_ object: T) where T: PersistentModel {
        context.delete(object)
        try? context.save()
    }
    
    /// Delete one or several objects of the specified type using a predicate.
    /// If you don’t provide a predicate, the context will remove all objects of the specified type from the persistent storage.
    func delete<T>(_ type: T.Type, predicate: Predicate<T>? = nil) -> Result<Bool, SwiftDataError> where T: PersistentModel {
        do {
            try context.delete(model: type, where: predicate)
            try? context.save()
            return .success(true)
        } catch (let error) {
            return .failure(SwiftDataError(error: error))
        }
    }
    
    /// Delete all objects
    func deleteAll() {
        context.container.deleteAllData() // erase() from iOS 18
        try? context.save()
    }
    
    /// Get the number of objects using a descriptor
    func fetchCount<T>(_ type: T.Type, descriptor: FetchDescriptor<T>) -> Int where T: PersistentModel {
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
