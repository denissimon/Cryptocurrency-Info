//
//  AssetDetailsViewModel.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 21.12.2020.
//

import Foundation
import SwiftEvents

class AssetDetailsViewModel {
    
    private let profileRepository: ProfileRepository
    private let priceRepository: PriceRepository
    
    // Bindings
    let data: Observable<Details> = Observable(Details())
    let showToast: Observable<String> = Observable("")
    let priceCurrency: Observable<PriceCurrency> = Observable(AppConfiguration.Other.selectedCurrency)
    let activityIndicatorVisibility: Observable<Bool> = Observable(false)
    
    init(asset: Asset, profileRepository: ProfileRepository, priceRepository: PriceRepository) {
        self.data.value.asset = asset
        self.profileRepository = profileRepository
        self.priceRepository = priceRepository
    }
    
    private func onNetworkError(_ msg: String = "") {
        if !msg.isEmpty {
            showToast.value = msg
        }
        self.activityIndicatorVisibility.value = false
    }
    
    func getDataSource() -> AssetDetailsDataSource {
        return AssetDetailsDataSource(with: data.value)
    }
    
    func getProfile(asset: String) {
        activityIndicatorVisibility.value = true
        
        Task.detached {
            let result = await self.profileRepository.getProfile(asset: asset)
            
            switch result {
            case .success(let profile):
                if let projectDetails = profile.projectDetails {
                    var editedProfile = profile
                    editedProfile.projectDetails = self.editLinksInProjectDetails(projectDetails)
                    self.data.value = Details(asset: self.data.value.asset, profile: editedProfile)
                    self.activityIndicatorVisibility.value = false
                } else {
                    self.onNetworkError()
                }
            case .failure(let error):
                if error.error != nil {
                    self.onNetworkError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
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
    
    func getPrice(asset: String) {
        Task.detached {
            let result = await self.priceRepository.getPrice(asset: asset)
            
            switch result {
            case .success(let price):
                var editedAsset = self.data.value.asset
                editedAsset?.priceUsd = price.priceUsd
                self.data.value = Details(asset: editedAsset, profile: self.data.value.profile)
            case .failure(let error):
                if error.error != nil {
                    self.onNetworkError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
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
}

