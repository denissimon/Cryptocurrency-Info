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
    private var currencyConversionService: CurrencyConversionService
    
    // Bindings
    let data: Observable<Details> = Observable(Details())
    let makeToast: Observable<String> = Observable("")
    let activityIndicatorVisibility: Observable<Bool> = Observable(false)
    
    var dataSource: AssetDetailsDataSource {
        AssetDetailsDataSource(with: data.value)
    }
    
    init(asset: Asset, profileRepository: ProfileRepository, priceRepository: PriceRepository, currencyConversionService: CurrencyConversionService) {
        self.data.value.asset = asset
        self.profileRepository = profileRepository
        self.priceRepository = priceRepository
        self.currencyConversionService = currencyConversionService
    }
    
    private func showError(_ msg: String = "") {
        if !msg.isEmpty {
            makeToast.value = msg
        }
        activityIndicatorVisibility.value = false
    }
    
    func getProfile() {
        guard let symbol = data.value.asset?.symbol else { return }
        
        activityIndicatorVisibility.value = true
        
        Task {
            let result = await profileRepository.getProfile(symbol: symbol)
            
            switch result {
            case .success(let profile):
                if let projectDetails = profile.projectDetails {
                    var updatedProfile = profile
                    updatedProfile.projectDetails = editLinksInProjectDetails(projectDetails)
                    data.value = Details(asset: data.value.asset, profile: updatedProfile)
                    activityIndicatorVisibility.value = false
                } else {
                    showError()
                }
            case .failure(let error):
                if error.error != nil {
                    showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        showError(NSLocalizedString("Profile data not found", comment: ""))
                    } else {
                        showError()
                    }
                } else {
                    showError()
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
    
    func updateData() {
        guard let symbol = data.value.asset?.symbol else { return }
        
        activityIndicatorVisibility.value = true
        
        Task {
            async let profile = profileRepository.getProfile(symbol: symbol)
            async let price = priceRepository.getPrice(symbol: symbol)
            
            let details = await (profile: profile, price: price)
            
            var profileToUpdate = data.value.profile
            var assetToUpdate = data.value.asset
            
            var shouldTriggerPriceChangedEvent = false
            
            switch details.profile {
            case .success(let profile):
                if let projectDetails = profile.projectDetails {
                    profileToUpdate?.projectDetails = editLinksInProjectDetails(projectDetails)
                } else {
                    showError()
                }
            case .failure(let error):
                if error.error != nil {
                    showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        showError(NSLocalizedString("Profile data not found", comment: ""))
                    } else {
                        showError()
                    }
                } else {
                    showError()
                }
                return
            }
            
            switch details.price {
            case .success(let price):
                if assetToUpdate != nil, assetToUpdate!.priceUsd != price.priceUsd {
                    assetToUpdate!.priceUsd = price.priceUsd
                    if AppConfiguration.Settings.selectedCurrency == .USD {
                        assetToUpdate!.price.amount = price.priceUsd
                    } else {
                        await currencyConversionService.convertCurrency(&assetToUpdate!)
                    }
                    shouldTriggerPriceChangedEvent = true
                }
            case .failure(let error):
                if error.error != nil {
                    showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        showError(NSLocalizedString("Asset data not found", comment: ""))
                    } else {
                        showError()
                    }
                } else {
                    showError()
                }
                return
            }
            
            if shouldTriggerPriceChangedEvent {
                SharedEvents.get.priceChanged.notify(assetToUpdate)
            }
            
            data.value = Details(asset: assetToUpdate, profile: profileToUpdate)
            
            activityIndicatorVisibility.value = false
        }
    }
}
