//
//  DefaultPriceRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

class DefaultPriceRepository: PriceRepository {
    
    private let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    private func getPrice(symbol: String, completionHandler: @escaping (Result<Price, NetworkError>) -> Void) {
        let endpoint = MessariAPI.price(symbol: symbol)
        apiInteractor.request(endpoint, type: Price.self) { result in
            completionHandler(result)
        }
    }
    
    func getPrice(symbol: String) async -> Result<Price, NetworkError> {
        await withCheckedContinuation { continuation in
            getPrice(symbol: symbol) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
