//
//  AssetRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

protocol AssetRepository {
    typealias AssetsResult = Result<Assets, NetworkError>

    func getAssets(page: Int) async -> AssetsResult
}
