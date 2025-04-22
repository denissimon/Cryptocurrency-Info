//
//  AssetsListViewModelTests.swift
//  CryptocurrencyInfoTests
//
//  Created by Denis Simon on 19.12.2020.
//

import XCTest
@testable import CryptocurrencyInfo

class AssetsListViewModelTests: XCTestCase {

    let dependencyContainer = DIContainer()
    
    var assetsListViewModel: AssetsListViewModel!
    
    var data: [Asset]? = nil
    var toastResult: String? = nil
    var assetsCompletionHandlerResult: Bool? = nil
    var activityIndicatorVisibilityResult: Bool? = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        assetsListViewModel = AssetsListViewModel(assetRepository: dependencyContainer.makeAssetRepository(), settingsRepository: dependencyContainer.makeSettingsRepository(), currencyConversionService: dependencyContainer.currencyConversionService)
        
        assetsListViewModel.data.bind(self) { [weak self] data in
            self?.data = data
        }
        
        assetsListViewModel.makeToast.bind(self) { [weak self] text in
            if !text.isEmpty {
                self?.toastResult = text
            }
        }
        
        assetsListViewModel.getAssetsCompletionHandler.bind(self) { [weak self] value in
            self?.assetsCompletionHandlerResult = value
        }
        
        assetsListViewModel.activityIndicatorVisibility.bind(self) { [weak self] value in
                self?.activityIndicatorVisibilityResult = value
        }
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        assetsListViewModel = nil
        data = nil
        toastResult = nil
        assetsCompletionHandlerResult = nil
        activityIndicatorVisibilityResult = nil
    }

    func testObservables() throws {
        var assetArr = [Asset]()
        assetArr.append(Asset(symbol: "BTC", name: "Bitcoin", priceUsd: 27000.0, price: Money()))
        assetArr.append(Asset(symbol: "ETH", name: "Ethereum", priceUsd: 700.0, price: Money()))
        
        assetsListViewModel.data.value = assetArr
        XCTAssertNotNil(data)
        XCTAssertEqual(data!.count, 2)
        
        assetsListViewModel.makeToast.value = "Some text for toast"
        XCTAssertEqual(toastResult, "Some text for toast")
        
        assetsListViewModel.getAssetsCompletionHandler.value = true
        XCTAssertEqual(assetsCompletionHandlerResult, true)
        
        assetsListViewModel.activityIndicatorVisibility.value = false
        XCTAssertEqual(activityIndicatorVisibilityResult, false)
        assetsListViewModel.activityIndicatorVisibility.value = true
        XCTAssertEqual(activityIndicatorVisibilityResult, true)
    }
}
