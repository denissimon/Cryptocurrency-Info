//
//  ProfileRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

protocol ProfileRepository {
    typealias ProfileResult = Result<Profile, NetworkError>
    //func getProfile(asset: String, completionHandler: @escaping (ProfileResult) -> Void)
    func getProfile(asset: String) async -> ProfileResult
}
