//
//  AssetDetailsViewModelTests.swift
//  CryptocurrencyInfoTests
//
//  Created by Denis Simon on 19.12.2020.
//

import XCTest
@testable import CryptocurrencyInfo

class AssetDetailsViewModelTests: XCTestCase {

    let dependencyContainer = DIContainer()
    
    var assetDetailsViewModel: AssetDetailsViewModel!
    
    var data: Details? = nil
    var toastResult: String? = nil
    var activityIndicatorVisibilityResult: Bool? = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let asset = Asset(symbol: "ETH", name: "Ethereum", priceUsd: 700.0, price: Money())
        assetDetailsViewModel = AssetDetailsViewModel(asset: asset, profileRepository: dependencyContainer.makeProfileRepository(), priceRepository: dependencyContainer.makePriceRepository(), currencyConversionService: dependencyContainer.currencyConversionService)
        
        assetDetailsViewModel.data.bind(self) { (data) in
            self.data = data
        }
        
        assetDetailsViewModel.makeToast.bind(self) { (text) in
            if !text.isEmpty {
                self.toastResult = text
            }
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
        activityIndicatorVisibilityResult = nil
    }

    func testObservables() throws {
        let asset = Asset(symbol: "BTC", name: "Bitcoin", priceUsd: 27000.0, price: Money())
        let detailsData = Details(asset: asset, profile: nil)
        
        assetDetailsViewModel.data.value = detailsData
        XCTAssertNotNil(data)
        XCTAssertEqual(data!.asset?.name, "Bitcoin")
        
        assetDetailsViewModel.makeToast.value = "Some new text for toast"
        XCTAssertEqual(toastResult, "Some new text for toast")
        
        assetDetailsViewModel.activityIndicatorVisibility.value = false
        XCTAssertEqual(activityIndicatorVisibilityResult, false)
        assetDetailsViewModel.activityIndicatorVisibility.value = true
        XCTAssertEqual(activityIndicatorVisibilityResult, true)
    }
    
    func testRegex() {
        let originalString = "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between <a href=\"https://messari.io/resource/node\">full nodes</a>, <a href=\"https://messari.io/resource/mining\">miners</a>, and developers."
        let expectedString = "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between full nodes, miners, and developers."
        let result = assetDetailsViewModel.editLinksInProjectDetails(originalString)
        XCTAssertEqual(result, expectedString)
    }
}
