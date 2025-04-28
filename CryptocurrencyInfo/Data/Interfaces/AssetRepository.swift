//
//  AssetRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import URLSessionAdapter

protocol AssetRepository {
    func getAssets(page: Int) async -> Result<Assets, NetworkError>
}
