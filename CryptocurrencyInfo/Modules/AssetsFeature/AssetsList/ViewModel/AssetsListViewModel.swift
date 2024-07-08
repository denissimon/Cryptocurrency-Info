//
//  AssetsListViewModel.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import Foundation
import SwiftEvents

class AssetsListViewModel {
    
    private var assetRepository: AssetRepository
    
    // Bindings
    var data: Observable<[Asset]> = Observable([])
    private var dataCopy = [Asset]()
    var priceCurrency: Observable<PriceCurrency> = Observable(AppConfiguration.Other.selectedCurrency)
    let showToast: Observable<String> = Observable("")
    let activityIndicatorVisibility: Observable<Bool> = Observable(false)
    let getAssetsCompletionHandler: Observable<Bool?> = Observable(nil)
    
    private(set) var currentPage = 0
    private(set) var assetsAreLoadingFromServer = false
    var searchMode = false
    
    init(assetRepository: AssetRepository) {
        self.assetRepository = assetRepository
        bind()
    }
    
    private func bind() {
        SharedEvents.get.priceChanged.subscribe(self, queue: .main) { [weak self] assetPrice in
            guard let self = self else { return }
            let data = self.data.value
            for asset in data {
                if asset.symbol == assetPrice.symbol {
                    asset.priceUsd = assetPrice.priceUsd
                }
            }
            self.data.value = data
        }
    }
    
    private func onNetworkError(_ msg: String = "") {
        if !msg.isEmpty {
            showToast.value = msg
        }
        self.activityIndicatorVisibility.value = false
    }
    
    func getDataSource() -> AssetsListDataSource {
        return AssetsListDataSource(with: data.value)
    }
    
    func getAssets(page: Int) {
        // If search mode is enabled and there are some results, we do not load new batches of assets
        guard searchMode == false || (searchMode && data.value.count == dataCopy.count) else { return }
        
        assetsAreLoadingFromServer = true
        
        activityIndicatorVisibility.value = true
        
        Task.detached {
            let result = await self.assetRepository.getAssets(page: page)
            
            switch result {
            case .success(let assets):
                if assets.data.count > 0 {
                    self.data.value += assets.data
                    self.currentPage = page
                    self.dataCopy = self.data.value
                }
                self.activityIndicatorVisibility.value = false
            case .failure(let error):
                if error.error != nil {
                    self.onNetworkError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        self.onNetworkError("Next page not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
            
            self.getAssetsCompletionHandler.value = nil
        }
    }
    
    func clearData() {
        self.data.value.removeAll()
    }
    
    func setAssetsAreLoadingFromServer(_ newValue: Bool) {
        self.assetsAreLoadingFromServer = newValue
    }
    
    func searchAsset(_ searchText: String) {
        if searchText.isEmpty {
            data.value = dataCopy
            return
        }
        
        var resultData = [Asset]()
        for asset in dataCopy {
            let editedSearchText = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if asset.symbol.lowercased().contains(editedSearchText) || asset.name.lowercased().contains(editedSearchText) {
                resultData.append(asset)
            }
        }
        data.value = resultData
    }
    
    func resetSearch() {
        data.value = dataCopy
        searchMode = false
    }
}
