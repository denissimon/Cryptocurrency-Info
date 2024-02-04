//
//  AssetDetailsViewModelTests.swift
//  CryptocurrencyInfoTests
//
//  Created by Denis Simon on 19.12.2020.
//

import XCTest
@testable import CryptocurrencyInfo

class AssetDetailsViewModelTests: XCTestCase {

    private(set) var dependencyContainer = DIContainer()
    
    var assetDetailsViewModel: AssetDetailsViewModel!
    
    var data: Details? = nil
    var toastResult: String? = nil
    var priceCurrencyResult: PriceCurrency? = nil
    var activityIndicatorVisibilityResult: Bool? = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let asset = Asset(symbol: "ETH", name: "Ethereum", metrics: Metrics(marketData: MarketData(priceUsd: 700.0)))
        assetDetailsViewModel = AssetDetailsViewModel(asset: asset, profileRepository: dependencyContainer.makeProfileRepository(), priceRepository: dependencyContainer.makePriceRepository())
        
        assetDetailsViewModel.data.bind(self) { (data) in
            self.data = data
        }
        
        assetDetailsViewModel.showToast.bind(self) { (text) in
            if !text.isEmpty {
                self.toastResult = text
            }
        }
        
        assetDetailsViewModel.priceCurrency.bind(self) { (priceCurrency) in
            self.priceCurrencyResult = priceCurrency
        }
        
        assetDetailsViewModel.activityIndicatorVisibility.bind(self) { (value) in
            self.activityIndicatorVisibilityResult = value
        }
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        assetDetailsViewModel = nil
        data = nil
        toastResult = nil
        priceCurrencyResult = nil
        activityIndicatorVisibilityResult = nil
    }

    func testObservables() throws {
        let asset = Asset(symbol: "BTC", name: "Bitcoin", metrics: Metrics(marketData: MarketData(priceUsd: 27000.0)))
        let detailsData = Details(asset: asset, profile: nil)
        
        assetDetailsViewModel.data.value = detailsData
        XCTAssertNotNil(data)
        XCTAssertEqual(data!.asset?.name, "Bitcoin")
        
        assetDetailsViewModel.showToast.value = "Some new text for toast"
        XCTAssertEqual(toastResult, "Some new text for toast")
        
        assetDetailsViewModel.priceCurrency.value = .euro
        XCTAssertEqual(priceCurrencyResult, .euro)
        
        assetDetailsViewModel.activityIndicatorVisibility.value = false
        XCTAssertEqual(activityIndicatorVisibilityResult, false)
        assetDetailsViewModel.activityIndicatorVisibility.value = true
        XCTAssertEqual(activityIndicatorVisibilityResult, true)
    }

    func testOnNetworkError() {
        assetDetailsViewModel.onNetworkError("Some new message")
        XCTAssertEqual(toastResult, "Some new message")
    }
    
    func testRegex() {
        let originalString = "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between <a href=\"https://messari.io/resource/node\">full nodes</a>, <a href=\"https://messari.io/resource/mining\">miners</a>, and developers."
        let expectedString = "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between full nodes, miners, and developers."
        let result = assetDetailsViewModel.editLinksInProjectDetails(originalString)
        XCTAssertEqual(result, expectedString)
    }
}
