//
//  AssetRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import URLSessionAdapter

protocol AssetRepository {
    typealias AssetsResult = Result<Assets, NetworkError>

    func getAssets(page: Int) async -> AssetsResult
}
