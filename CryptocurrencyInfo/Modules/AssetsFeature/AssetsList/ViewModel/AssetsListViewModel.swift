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
    private var settingsRepository: SettingsRepository
    private var currencyConversionService: CurrencyConversionService
    
    // Bindings
    var data: Observable<[Asset]> = Observable([])
    private var dataCopy = [Asset]()
    let makeToast: Observable<String> = Observable("")
    let activityIndicatorVisibility: Observable<Bool> = Observable(false)
    let getAssetsCompletionHandler: Observable<Bool?> = Observable(nil)
    
    private(set) var currentPage = 0
    private(set) var assetsAreLoadingFromServer = false
    var searchMode = false
    
    let screenTitle = NSLocalizedString("Today's Cryptocurrency Info", comment: "")
    
    init(assetRepository: AssetRepository, settingsRepository: SettingsRepository, currencyConversionService: CurrencyConversionService) {
        self.assetRepository = assetRepository
        self.settingsRepository = settingsRepository
        self.currencyConversionService = currencyConversionService
        setup()
        bind()
    }
    
    private func setup() {
        Task {
            if let storedSelectedCurrency = await settingsRepository.getSelectedCurrency() {
                AppConfiguration.Settings.selectedCurrency = storedSelectedCurrency
            }
        }
        
        // For testing: we сan simulate as if the app user changed the currency
        /*DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            Task {
                let newSelectedCurrency: Currency = .EUR
                let _ = await self.settingsRepository.saveSelectedCurrency(newSelectedCurrency)
                AppConfiguration.Settings.selectedCurrency = newSelectedCurrency
            }
        }*/
    }
    
    private func bind() {
        SharedEvents.get.priceChanged.subscribe(self, queue: .main) { [weak self] updatedAsset in
            guard let self = self, updatedAsset != nil else { return }
            let data = self.data.value
            for asset in data {
                if asset.symbol == updatedAsset!.symbol {
                    asset.price.amount = updatedAsset!.price.amount
                    break
                }
            }
            self.data.value = data
        }
    }
    
    private func showError(_ msg: String = "") {
        if !msg.isEmpty {
            makeToast.value = msg
        }
        activityIndicatorVisibility.value = false
    }
    
    func getDataSource() -> AssetsListDataSource {
        AssetsListDataSource(with: data.value)
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
                var data = assets.data
                if data.count > 0 {
                    await self.currencyConversionService.convertCurrency(&data)
                    self.data.value += data
                    self.currentPage = page
                    self.dataCopy = self.data.value
                }
                self.activityIndicatorVisibility.value = false
            case .failure(let error):
                if error.error != nil {
                    self.showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        self.showError(NSLocalizedString("Next page not found", comment: ""))
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
                }
            }
            
            self.getAssetsCompletionHandler.value = nil
        }
    }
    
    func clearData() {
        data.value.removeAll()
    }
    
    func setAssetsAreLoadingFromServer(_ newValue: Bool) {
        assetsAreLoadingFromServer = newValue
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
