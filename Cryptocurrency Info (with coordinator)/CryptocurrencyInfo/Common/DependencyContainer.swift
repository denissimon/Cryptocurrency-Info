//
//  DependencyContainer.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

class DependencyContainer {
    
    func makeAssetsListViewController() -> AssetsListViewController {
        let assetsListVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssetsList") as! AssetsListViewController
        assetsListVc.navigator = (UIApplication.shared.delegate as! AppDelegate).coordinator
        return assetsListVc
    }
    
    func makeAssetDetailsViewController(asset: Asset) -> AssetDetailsViewController {
        let assetDetailsVc = UIStoryboard(name: "AssetDetails", bundle: nil).instantiateViewController(withIdentifier: "AssetDetails") as! AssetDetailsViewController
        assetDetailsVc.navigationItem.title = asset.name
        assetDetailsVc.viewModel = AssetDetailsViewModel(networkService: NetworkService(), asset: asset)
        return assetDetailsVc
    }
}
