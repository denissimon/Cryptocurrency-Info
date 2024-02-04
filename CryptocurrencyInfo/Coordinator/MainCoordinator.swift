//
//  MainCoordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 15.11.2021.
//

import UIKit

protocol MainCoordinatorDIContainer {
    func makeAssetsListViewController(coordinator: AssetsListViewControllerCoordinatorDelegate) -> AssetsListViewController
    func makeAssetDetailsViewController(asset: Asset) -> AssetDetailsViewController
}

class MainCoordinator: FlowCoordinator {
    
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
    
    func showAssetsList() {
        let assetsListVC = dependencyContainer.makeAssetsListViewController(coordinator: self)
        navigationController.pushViewController(assetsListVC, animated: false)
    }
    
    func showAssetDetails(_ asset: Asset) {
        let assetDetailsVC = dependencyContainer.makeAssetDetailsViewController(asset: asset)
        navigationController.pushViewController(assetDetailsVC, animated: true)
    }
}

extension MainCoordinator: AssetsListViewControllerCoordinatorDelegate {
    func onAssetDetails(_ asset: Asset) {
        showAssetDetails(asset)
    }
}
