//
//  DefaultAssetRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

class DefaultAssetRepository: AssetRepository {
    
    private let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    private func getAssets(page: Int, completionHandler: @escaping (Result<Assets, NetworkError>) -> Void) {
        let endpoint = MessariAPI.assets(page: page)
        apiInteractor.request(endpoint, type: Assets.self) { result in
            completionHandler(result)
        }
    }
    
    func getAssets(page: Int) async -> Result<Assets, NetworkError> {
        await withCheckedContinuation { continuation in
            getAssets(page: page) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
