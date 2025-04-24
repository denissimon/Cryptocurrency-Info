//
//  UserDefaultsAdapter.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 16.04.2025.
//

// https://gist.github.com/denissimon/5d613b3e34a8595d451abeb0d43e2c08

import Foundation

class UserDefaultsAdapter {
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func set<T>(value: T, forKey: String) {
        if !forKey.isEmpty {
            defaults.set(value, forKey: forKey)
        }
    }
    
    func get(forKey: String) -> String? {
        var value: String? = nil
        
        if !forKey.isEmpty {
            value = defaults.string(forKey: forKey)
        }
        
        return value
    }
    
    func remove(forKey: String) {
        if let keyValue = defaults.string(forKey: forKey) {
            defaults.removeObject(forKey: keyValue)
        }
    }
    
    func removeAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
    }
}

