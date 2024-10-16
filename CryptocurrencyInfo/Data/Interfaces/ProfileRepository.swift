//
//  ProfileRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import URLSessionAdapter

protocol ProfileRepository {
    typealias ProfileResult = Result<Profile, NetworkError>
    
    func getProfile(symbol: String) async -> ProfileResult
}
