//
//  ProfileRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import URLSessionAdapter

protocol ProfileRepository {
    func getProfile(symbol: String) async -> Result<Profile, NetworkError>
}
