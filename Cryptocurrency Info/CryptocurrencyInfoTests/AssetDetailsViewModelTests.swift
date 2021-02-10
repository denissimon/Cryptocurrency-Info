//
//  AssetDetailsViewModelTests.swift
//  CryptocurrencyInfoTests
//
//  Created by Denis Simon on 19.12.2020.
//

import XCTest
@testable import CryptocurrencyInfo

// Tests for AssetDetailsViewModel
class AssetDetailsViewModelTests: XCTestCase {

    var assetDetailsViewModel: AssetDetailsViewModel!
    
    var updateDataResult: Details? = nil
    var showToastResult: String? = nil
    var setPriceCurrencyResult: PriceCurrency? = nil
    var activityIndicatorVisibilityResult: Bool? = nil
    var chartSpinnerVisibilityResult: Bool? = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        let asset = Asset(symbol: "ETH", name: "Ethereum", metrics: Metrics(marketData: MarketData(priceUsd: 700.0)))
        assetDetailsViewModel = AssetDetailsViewModel(networkService: NetworkService(), asset: asset)
        
        assetDetailsViewModel.updateData.addSubscriber(target: self) { (self, data) in
            self.updateDataResult = data
        }
        
        assetDetailsViewModel.showToast.addSubscriber(target: self) { (self, text) in
            if !text.isEmpty {
                self.showToastResult = text
            }
        }
        
        assetDetailsViewModel.setPriceCurrency.addSubscriber(target: self) { (self, priceCurrency) in
            self.setPriceCurrencyResult = priceCurrency
        }
        
        assetDetailsViewModel.activityIndicatorVisibility.didChanged.addSubscriber(target: self) { (self, value) in
            self.activityIndicatorVisibilityResult = value.new
        }
        
        assetDetailsViewModel.chartSpinnerVisibility.didChanged.addSubscriber(target: self) { (self, value) in
            self.chartSpinnerVisibilityResult = value.new
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        assetDetailsViewModel = nil
        updateDataResult = nil
        showToastResult = nil
        setPriceCurrencyResult = nil
        activityIndicatorVisibilityResult = nil
        chartSpinnerVisibilityResult = nil
    }

    func testTriggerEvents() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asset = Asset(symbol: "BTC", name: "Bitcoin", metrics: Metrics(marketData: MarketData(priceUsd: 27000.0)))
        let detailsData = Details(asset: asset, profile: nil, chartData: nil)
        
        assetDetailsViewModel.updateData.trigger(detailsData)
        XCTAssertNotNil(updateDataResult)
        XCTAssertEqual(updateDataResult!.asset?.name, "Bitcoin")
        
        assetDetailsViewModel.showToast.trigger("Some new text for toast")
        XCTAssertEqual(showToastResult, "Some new text for toast")
        
        assetDetailsViewModel.setPriceCurrency.trigger(.euro)
        XCTAssertEqual(setPriceCurrencyResult, .euro)
        
        assetDetailsViewModel.activityIndicatorVisibility.didChanged.trigger((new: false, old: true))
        XCTAssertEqual(activityIndicatorVisibilityResult, false)
        assetDetailsViewModel.activityIndicatorVisibility.didChanged.trigger((new: true, old: false))
        XCTAssertEqual(activityIndicatorVisibilityResult, true)
        
        assetDetailsViewModel.chartSpinnerVisibility.didChanged.trigger((new: false, old: true))
        XCTAssertEqual(chartSpinnerVisibilityResult, false)
        assetDetailsViewModel.chartSpinnerVisibility.didChanged.trigger((new: true, old: false))
        XCTAssertEqual(chartSpinnerVisibilityResult, true)
    }

    func testOnNetworkError() {
        assetDetailsViewModel.onNetworkError("Some new message")
        XCTAssertEqual(showToastResult, "Some new message")
    }
    
    func testRegex() {
        let originalString = "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between <a href=\"https://messari.io/resource/node\">full nodes</a>, <a href=\"https://messari.io/resource/mining\">miners</a>, and developers."
        let expectedString = "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between full nodes, miners, and developers."
        let result = assetDetailsViewModel.editLinksInProjectDetails(originalString)
        XCTAssertEqual(result, expectedString)
    }
}
