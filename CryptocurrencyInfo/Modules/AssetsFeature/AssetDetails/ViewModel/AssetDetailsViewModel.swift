//
//  AssetDetailsViewModel.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 21.12.2020.
//

import Foundation
import SwiftEvents

class AssetDetailsViewModel {
    
    let profileRepository: ProfileRepository
    let chartRepository: ChartRepository
    let priceRepository: PriceRepository
    
    private(set) var chartPeriod: TimeSeriesPeriod = .month
    private(set) var chartInterval: TimeSeriesInterval = .day
    
    // Bindings
    let data: Observable<Details> = Observable(Details())
    let showToast: Observable<String> = Observable("")
    let priceCurrency: Observable<PriceCurrency> = Observable(.usd)
    let activityIndicatorVisibility: Observable<Bool> = Observable(false)
    let chartSpinnerVisibility: Observable<Bool> = Observable(false)
    
    init(asset: Asset, profileRepository: ProfileRepository, chartRepository: ChartRepository, priceRepository: PriceRepository) {
        self.data.value.asset = asset
        self.profileRepository = profileRepository
        self.chartRepository = chartRepository
        self.priceRepository = priceRepository
    }
    
    func getDataSource() -> AssetDetailsDataSource {
        return AssetDetailsDataSource(with: data.value)
    }
    
    func onNetworkError(_ msg: String = "") {
        if !msg.isEmpty {
            showToast.value = msg
        }
        self.activityIndicatorVisibility.value = false
    }
    
    func getProfile(asset: String) {
        activityIndicatorVisibility.value = true
        
        Task.detached {
            let result = await self.profileRepository.getProfile(asset: asset)
            
            switch result {
            case .success(let profile):
                if let projectDetails = profile.data.profile.general.overview.projectDetails {
                    var editedProfile = profile
                    editedProfile.data.profile.general.overview.projectDetails = self.editLinksInProjectDetails(projectDetails)
                    self.data.value = Details(asset: self.data.value.asset, profile: editedProfile, chartData: self.data.value.chartData)
                    self.activityIndicatorVisibility.value = false
                } else {
                    self.onNetworkError()
                }
            case .failure(let error):
                if error.error != nil {
                    self.onNetworkError(error.error!.localizedDescription)
                } else if error.code != nil {
                    if error.code! == 404 {
                        self.onNetworkError("Profile data not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
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
        
        let currentChartPeriod = chartPeriod
        
        Task.detached {
            let result = await self.chartRepository.getChart(input: input)
            
            // If the chartPeriod was changed by the user during this time, we do not update the UI with new data
            if currentChartPeriod != self.chartPeriod { return }
            
            switch result {
            case .success(let chartData):
                self.data.value = Details(asset: self.data.value.asset, profile: self.data.value.profile, chartData: chartData)
                self.chartSpinnerVisibility.value = false
            case .failure(let error):
                if error.error != nil {
                    self.onNetworkError(error.error!.localizedDescription)
                } else if error.code != nil {
                    if error.code! == 404 {
                        self.onNetworkError("Chart data not found")
                    } else {
                        self.onNetworkError()
                    }
                } else {
                    self.onNetworkError()
                }
            }
        }
    }
    
    func getPrice(asset: String) {
        
        Task.detached {
            let result = await self.priceRepository.getPrice(asset: asset)
            
            switch result {
            case .success(let price):
                var editedAssets = self.data.value.asset
                editedAssets?.metrics.marketData.priceUsd = price.data.marketData.priceUsd
                self.data.value = Details(asset: editedAssets, profile: self.data.value.profile, chartData: self.data.value.chartData)
            case .failure(let error):
                if error.error != nil {
                    self.onNetworkError(error.error!.localizedDescription)
                } else if error.code != nil {
                    if error.code! == 404 {
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
        
        if let asset = data.value.asset {
            getChart(input: TimeSeriesInputData(asset: asset.symbol, period: chartPeriod, interval: chartInterval))
        }
    }
}

