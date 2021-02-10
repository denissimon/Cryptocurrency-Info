//
//  AssetsListViewModelTests.swift
//  CryptocurrencyInfoTests
//
//  Created by Denis Simon on 19.12.2020.
//

import XCTest
@testable import CryptocurrencyInfo

// Tests for AssetsListViewModel
class AssetsListViewModelTests: XCTestCase {

    var assetsListViewModel: AssetsListViewModel!
    
    var updateDataResult: [Asset]? = nil
    var showToastResult: String? = nil
    var setPriceCurrencyResult: PriceCurrency? = nil
    var getAssetsCompletionHandlerResult: Bool? = nil
    var activityIndicatorVisibilityResult: Bool? = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        assetsListViewModel = AssetsListViewModel(networkService: NetworkService())
        
        assetsListViewModel.updateData.addSubscriber(target: self) { (self, data) in
            self.updateDataResult = data
        }
        
        assetsListViewModel.showToast.addSubscriber(target: self) { (self, text) in
            if !text.isEmpty {
                self.showToastResult = text
            }
        }
        
        assetsListViewModel.setPriceCurrency.addSubscriber(target: self) { (self, priceCurrency) in
            self.setPriceCurrencyResult = priceCurrency
        }
        
        assetsListViewModel.getAssetsCompletionHandler.addSubscriber(target: self) { (self, value) in
            self.getAssetsCompletionHandlerResult = value
        }
        
        assetsListViewModel.activityIndicatorVisibility.didChanged.addSubscriber(target: self) { (self, value) in
                self.activityIndicatorVisibilityResult = value.new
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        assetsListViewModel = nil
        updateDataResult = nil
        showToastResult = nil
        setPriceCurrencyResult = nil
        getAssetsCompletionHandlerResult = nil
        activityIndicatorVisibilityResult = nil
    }

    func testTriggerEvents() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var assetArr = [Asset]()
        assetArr.append(Asset(symbol: "BTC", name: "Bitcoin", metrics: Metrics(marketData: MarketData(priceUsd: 27000.0))))
        assetArr.append(Asset(symbol: "ETH", name: "Ethereum", metrics: Metrics(marketData: MarketData(priceUsd: 700.0))))
        
        assetsListViewModel.updateData.trigger(assetArr)
        XCTAssertNotNil(updateDataResult)
        XCTAssertEqual(updateDataResult!.count, 2)
        
        assetsListViewModel.showToast.trigger("Some text for toast")
        XCTAssertEqual(showToastResult, "Some text for toast")
        
        assetsListViewModel.setPriceCurrency.trigger(.euro)
        XCTAssertEqual(setPriceCurrencyResult, .euro)
        
        assetsListViewModel.getAssetsCompletionHandler.trigger(true)
        XCTAssertEqual(getAssetsCompletionHandlerResult, true)
        
        assetsListViewModel.activityIndicatorVisibility.didChanged.trigger((new: false, old: true))
        XCTAssertEqual(activityIndicatorVisibilityResult, false)
        assetsListViewModel.activityIndicatorVisibility.didChanged.trigger((new: true, old: false))
        XCTAssertEqual(activityIndicatorVisibilityResult, true)
    }

    func testOnNetworkError() {
        assetsListViewModel.onNetworkError("Some message")
        XCTAssertEqual(showToastResult, "Some message")
        XCTAssertEqual(activityIndicatorVisibilityResult, false)
    }
}
