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
    
    func getDataSource() -> AssetDetailsDataSource {
        AssetDetailsDataSource(with: data.value)
    }
    
    func getProfile() {
        guard let symbol = data.value.asset?.symbol else { return }
        
        activityIndicatorVisibility.value = true
        
        Task.detached {
            let result = await self.profileRepository.getProfile(symbol: symbol)
            
            switch result {
            case .success(let profile):
                if let projectDetails = profile.projectDetails {
                    var updatedProfile = profile
                    updatedProfile.projectDetails = self.editLinksInProjectDetails(projectDetails)
                    self.data.value = Details(asset: self.data.value.asset, profile: updatedProfile)
                    self.activityIndicatorVisibility.value = false
                } else {
                    self.showError()
                }
            case .failure(let error):
                if error.error != nil {
                    self.showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        self.showError(NSLocalizedString("Profile data not found", comment: ""))
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
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
        
        Task.detached {
            async let profile = self.profileRepository.getProfile(symbol: symbol)
            async let price = self.priceRepository.getPrice(symbol: symbol)
            
            let details = await (profile: profile, price: price)
            
            var profileToUpdate = self.data.value.profile
            var assetToUpdate = self.data.value.asset
            
            var shouldTriggerPriceChangedEvent = false
            
            switch details.profile {
            case .success(let profile):
                if let projectDetails = profile.projectDetails {
                    profileToUpdate?.projectDetails = self.editLinksInProjectDetails(projectDetails)
                } else {
                    self.showError()
                }
            case .failure(let error):
                if error.error != nil {
                    self.showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        self.showError(NSLocalizedString("Profile data not found", comment: ""))
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
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
                        await self.currencyConversionService.convertCurrency(&assetToUpdate!)
                    }
                    shouldTriggerPriceChangedEvent = true
                }
            case .failure(let error):
                if error.error != nil {
                    self.showError(error.error!.localizedDescription)
                } else if error.statusCode != nil {
                    if error.statusCode! == 404 {
                        self.showError(NSLocalizedString("Asset data not found", comment: ""))
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
                }
                return
            }
            
            if shouldTriggerPriceChangedEvent {
                SharedEvents.get.priceChanged.notify(assetToUpdate)
            }
            
            self.data.value = Details(asset: assetToUpdate, profile: profileToUpdate)
            
            self.activityIndicatorVisibility.value = false
        }
    }
}
