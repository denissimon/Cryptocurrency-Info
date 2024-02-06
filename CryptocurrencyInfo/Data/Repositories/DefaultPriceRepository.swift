//
//  DefaultPriceRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

class DefaultPriceRepository: PriceRepository {
    
    let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    private func getPrice(asset: String, completionHandler: @escaping (Result<Price, NetworkError>) -> Void) {
        let endpoint = MessariAPI.price(asset: asset)
        apiInteractor.request(endpoint, type: Price.self) { result in
            completionHandler(result)
        }
    }
    
    func getPrice(asset: String) async -> Result<Price, NetworkError> {
        await withCheckedContinuation { continuation in
            getPrice(asset: asset) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
