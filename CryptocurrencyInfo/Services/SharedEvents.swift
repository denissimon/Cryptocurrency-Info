//
//  SharedEvents.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 08.07.2024.
//

import Foundation
import SwiftEvents

class SharedEvents {
    
    public static let get = SharedEvents()
    
    private init() {}
    
    public let priceChanged = Event<Asset?>()
}
