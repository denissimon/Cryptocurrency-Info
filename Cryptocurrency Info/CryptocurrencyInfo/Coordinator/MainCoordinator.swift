//
//  MainCoordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 15.11.2021.
//

import UIKit

protocol MainCoordinatorDIContainer {
    func makeAssetsListViewController(actions: AssetsListCoordinatorActions) -> AssetsListViewController
    func makeAssetDetailsViewController(asset: Asset) -> AssetDetailsViewController
}

class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    let dependencyContainer: MainCoordinatorDIContainer
        
    // MARK: - Initializer
    init(navigationController: UINavigationController, dependencyContainer: MainCoordinatorDIContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Methods
    func start(completionHandler: CoordinatorStartCompletionHandler?) {
        showAssetsList()
    }
    
    private func showAssetsList() {
        let actions = AssetsListCoordinatorActions(
            showAssetDetails: showAssetDetails
        )
        let assetsListVC = dependencyContainer.makeAssetsListViewController(actions: actions)
        navigationController.pushViewController(assetsListVC, animated: false)
    }
    
    private func showAssetDetails(asset: Asset) {
        let assetDetailsVC = dependencyContainer.makeAssetDetailsViewController(asset: asset)
        navigationController.pushViewController(assetDetailsVC, animated: true)
    }
}

