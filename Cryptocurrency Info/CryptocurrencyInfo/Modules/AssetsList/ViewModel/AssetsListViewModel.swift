//
//  AssetsListViewModel.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import Foundation
import SwiftEvents // In this project, SwiftEvents is used for a simpler and more modern closure based implementation of Delegation pattern, as well as for implementation of MVVM bindings. As an alternative, RxSwift or Combine can be used for bindings. As for Combine, it requires iOS 13+ deployment target. Combine also, like SwiftEvents, is based on Observable (analog of KVO in pure Swift) and Event (pub-sub) mechanisms, and even the syntax is very similar. SwiftEvents, however, is much lighter and simpler, was created before Combine, and can be used with earlier versions of iOS.

class AssetsListViewModel {
    
    var networkService: NetworkService
    
    private(set) var data = [Asset]() {
        didSet {
            self.updateData.trigger(self.data)
        }
    }
    
    private(set) var priceCurrency: PriceCurrency = .usd {
        didSet {
            setPriceCurrency.trigger(self.priceCurrency)
        }
    }
    
    private(set) var currentPage = 0 {
        didSet {
            print("currentPage:",currentPage)
        }
    }
    
    private(set) var assetsAreLoadingFromServer = false
    
    // Delegates
    let updateData = Event<[Asset]>()
    let showToast = Event<String>()
    let setPriceCurrency = Event<PriceCurrency>()
    let getAssetsCompletionHandler = Event<Bool?>()
    
    // Bindings
    let activityIndicatorVisibility = Observable<Bool>(false)
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getDataSource() -> AssetsListDataSource {
        return AssetsListDataSource(with: data)
    }
    
    func onNetworkError(_ msg: String = "") {
        if !msg.isEmpty {
            self.showToast.trigger(msg)
        }
        self.activityIndicatorVisibility.value = false
    }
    
    func getAssets(page: Int) {
        assetsAreLoadingFromServer = true
        
        activityIndicatorVisibility.value = true
        
        let endpoint = MessariAPI.assets(page: page)
        let params = HTTPParams(httpBody: nil, cachePolicy: nil, timeoutInterval: 7.0, headerValues:[
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue),
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue),
            (value: Constants.ProductionServer.messariApiKey, forHTTPHeaderField: HTTPHeaderField.xMessariApiKey.rawValue)])
        
        networkService.requestEndpoint(endpoint, params: params, type: Assets.self) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .done(let assets):
                //print("assets:",assets)
                if assets.data.count > 0 {
                    self.data += assets.data
                    self.currentPage = page
                }
                self.activityIndicatorVisibility.value = false
            case .error(let error):
                if error.0 != nil {
                    self.onNetworkError(error.0!.localizedDescription)
                } else if error.1 != nil {
                    if error.1! == 404 {
                        self.onNetworkError("Next page not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
            
            self.getAssetsCompletionHandler.trigger(nil)
        }
    }
    
    func clearData() {
        self.data.removeAll()
    }
    
    func setAssetsAreLoadingFromServer(_ newValue: Bool) {
        self.assetsAreLoadingFromServer = newValue
    }
}
