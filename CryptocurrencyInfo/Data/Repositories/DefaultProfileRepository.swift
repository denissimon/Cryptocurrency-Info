//
//  DefaultProfileRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

class DefaultProfileRepository: ProfileRepository {
    
    private let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    private func getProfile(symbol: String, completionHandler: @escaping (Result<Profile, NetworkError>) -> Void) {
        let endpoint = MessariAPI.profile(symbol: symbol)
        apiInteractor.request(endpoint, type: Profile.self) { result in
            completionHandler(result)
        }
    }
    
    func getProfile(symbol: String) async -> Result<Profile, NetworkError> {
        await withCheckedContinuation { continuation in
            getProfile(symbol: symbol) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
