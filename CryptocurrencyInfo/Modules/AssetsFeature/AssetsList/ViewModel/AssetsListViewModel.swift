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
    private var dataCopy: [Asset] = []
    let makeToast: Observable<String> = Observable("")
    let activityIndicatorVisibility: Observable<Bool> = Observable(false)
    
    private(set) var currentPage = 0
    
    private var searchMode = false
    
    private var taskIsRunning = false
    private var currentTask: Task<Void, Never>?
    
    var dataSource: AssetsListDataSource {
        AssetsListDataSource(with: data.value)
    }
    
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
            guard let self, updatedAsset != nil else { return }
            let data = data.value
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
    
    func getAssets(page: Int) {
        // If search mode is enabled and there are some results, we do not load new batches of assets
        guard searchMode == false || (searchMode && data.value.count == dataCopy.count) else { return }
        
        Task {
            await _getAssets(page: page).value
        }
    }
    
    private func _getAssets(page: Int) -> Task<Void, Never> {
        if let currentTask, taskIsRunning {
            return currentTask
        }
        
        taskIsRunning = true
        activityIndicatorVisibility.value = true
        
        currentTask?.cancel()
        
        let task = Task {
            let result = await assetRepository.getAssets(page: page)
            
            if Task.isCancelled { return }
            
            switch result {
            case .success(let assets):
                var data = assets.data
                if data.count > 0 {
                    await currencyConversionService.convertCurrency(&data)
                    self.data.value += data
                    currentPage = page
                    dataCopy = self.data.value
                }
                activityIndicatorVisibility.value = false
            case .failure(let error):
                if error.error != nil {
                    showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        showError(NSLocalizedString("Next page not found", comment: ""))
                    } else {
                        showError()
                    }
                } else {
                    showError()
                }
            }
            
            taskIsRunning = false
        }
        
        // Cache the current task to avoid sending network requests for each call
        currentTask = task
        return task
    }
    
    func clearData() {
        data.value.removeAll()
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
    
    func startSearch() {
        searchMode = true
    }
    
    func resetSearch() {
        data.value = dataCopy
        searchMode = false
    }
    
    func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
        taskIsRunning = false
    }
}
