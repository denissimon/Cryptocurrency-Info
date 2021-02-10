//
//  AssetDetailsViewModel.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 21.12.2020.
//

import Foundation
import SwiftEvents // In this project, SwiftEvents is used for a simpler and more modern closure based implementation of Delegation pattern, as well as for implementation of MVVM bindings. As an alternative, RxSwift or Combine can be used for bindings. As for Combine, it requires iOS 13+ deployment target. Combine also, like SwiftEvents, is based on Observable (analog of KVO in pure Swift) and Event (pub-sub) mechanisms, and even the syntax is very similar. SwiftEvents, however, is much lighter and simpler, was created before Combine, and can be used with earlier versions of iOS.

class AssetDetailsViewModel {
    
    var networkService: NetworkService
    
    private(set) var data = Details() {
        didSet {
            self.updateData.trigger(self.data)
        }
    }
    
    private(set) var priceCurrency: PriceCurrency = .usd {
        didSet {
            setPriceCurrency.trigger(self.priceCurrency)
        }
    }
    
    private(set) var chartPeriod: TimeSeriesPeriod = .month
    private(set) var chartInterval: TimeSeriesInterval = .day
    
    // Delegates
    let updateData = Event<Details>()
    let showToast = Event<String>()
    let setPriceCurrency = Event<PriceCurrency>()
    
    // Bindings
    let activityIndicatorVisibility = Observable<Bool>(false)
    let chartSpinnerVisibility = Observable<Bool>(false)
    
    init(networkService: NetworkService, asset: Asset) {
        self.networkService = networkService
        self.data.asset = asset
    }
    
    func getDataSource() -> AssetDetailsDataSource {
        return AssetDetailsDataSource(with: data)
    }
    
    func onNetworkError(_ msg: String = "") {
        if !msg.isEmpty {
            self.showToast.trigger(msg)
        }
    }
    
    func getProfile(asset: String) {
        activityIndicatorVisibility.value = true
        
        let endpoint = MessariAPI.profile(asset: asset)
        let params = HTTPParams(httpBody: nil, cachePolicy: nil, timeoutInterval: 7.0, headerValues:[
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue),
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue),
            (value: Constants.ProductionServer.messariApiKey, forHTTPHeaderField: HTTPHeaderField.xMessariApiKey.rawValue)])
        
        networkService.requestEndpoint(endpoint, params: params, type: Profile.self) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .done(let profile):
                //print("profile:",profile)
                if let projectDetails = profile.data.profile.general.overview.projectDetails {
                    var editedProfile = profile
                    editedProfile.data.profile.general.overview.projectDetails = self.editLinksInProjectDetails(projectDetails)
                    self.data.profile = editedProfile
                }
                self.updateData.trigger(self.data)
            case .error(let error):
                if error.0 != nil {
                    self.onNetworkError(error.0!.localizedDescription)
                } else if error.1 != nil {
                    if error.1! == 404 {
                        self.onNetworkError("Profile data not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
            self.activityIndicatorVisibility.value = false
        }
    }
    
    /*
     Returns the projectDetails string without html links (only text). E.g.:
     
     "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between <a href="https://messari.io/resource/node">full nodes</a>, <a href="https://messari.io/resource/mining">miners</a>, and developers."
     ->
     "The Bitcoin network is an emergent decentralized monetary institution that exists through the interplay between full nodes, miners, and developers."
     
     Alternatively, for the purpose of showing links, html links can be converted to links within an attributed string, or WKWebView can be used
     */
    func editLinksInProjectDetails(_ projectDetails: String) -> String {
        let regex = try! NSRegularExpression(pattern: "((<a).*?(\">))|(</a>)", options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: projectDetails, options: [], range: NSRange(0..<projectDetails.utf16.count), withTemplate: "")
    }
    
    func getChart(input: TimeSeriesInputData) {
        chartSpinnerVisibility.value = true
        
        let endpoint = MessariAPI.timeSeries(data: input)
        let params = HTTPParams(httpBody: nil, cachePolicy: nil, timeoutInterval: 7.0, headerValues:[
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue),
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue),
            (value: Constants.ProductionServer.messariApiKey, forHTTPHeaderField: HTTPHeaderField.xMessariApiKey.rawValue)])
        
        let currentChartPeriod = chartPeriod
        
        networkService.requestEndpoint(endpoint, params: params, type: Chart.self) { [weak self] (result) in
            guard let self = self else { return }
            
            // Do not update the UI with data from the server if the chartPeriod was changed by the user during this time
            if currentChartPeriod != self.chartPeriod { return }
            
            switch result {
            case .done(let chartData):
                //print("chartData:",chartData)
                self.data.chartData = chartData
                self.updateData.trigger(self.data)
            case .error(let error):
                if error.0 != nil {
                    self.onNetworkError(error.0!.localizedDescription)
                } else if error.1 != nil {
                    if error.1! == 404 {
                        self.onNetworkError("Chart data not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
            self.chartSpinnerVisibility.value = false
        }
    }
    
    func getPrice(asset: String) {
        let endpoint = MessariAPI.price(asset: asset)
        let params = HTTPParams(httpBody: nil, cachePolicy: nil, timeoutInterval: 7.0, headerValues:[
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue),
            (value: ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue),
            (value: Constants.ProductionServer.messariApiKey, forHTTPHeaderField: HTTPHeaderField.xMessariApiKey.rawValue)])
        
        networkService.requestEndpoint(endpoint, params: params, type: Price.self) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .done(let price):
                //print("price:",price)
                self.data.asset?.metrics.marketData.priceUsd = price.data.marketData.priceUsd
                self.updateData.trigger(self.data)
            case .error(let error):
                if error.0 != nil {
                    self.onNetworkError(error.0!.localizedDescription)
                } else if error.1 != nil {
                    if error.1! == 404 {
                        self.onNetworkError("Asset data not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
        }
    }
    
    func onPeriodSegmentedControlChanged(_ value: Int) {
        switch value {
        case 1:
            chartPeriod = .quarter
        case 2:
            chartPeriod = .halfYear
        case 3:
            chartPeriod = .year
        default:
            chartPeriod = .month
        }
        
        if let asset = data.asset {
            getChart(input: TimeSeriesInputData(asset: asset.symbol, period: chartPeriod, interval: chartInterval))
        }
    }
}

