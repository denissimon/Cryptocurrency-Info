//
//  DefaultProfileRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation
import URLSessionAdapter

class DefaultProfileRepository: ProfileRepository {
    
    let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    private func getProfile(asset: String, completionHandler: @escaping (Result<Profile, NetworkError>) -> Void) {
        let endpoint = MessariAPI.profile(asset: asset)
        apiInteractor.request(endpoint, type: Profile.self) { result in
            completionHandler(result)
        }
    }
    
    func getProfile(asset: String) async -> Result<Profile, NetworkError> {
        await withCheckedContinuation { continuation in
            getProfile(asset: asset) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
