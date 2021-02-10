//
//  AppCoordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

typealias AssetsListVcFactory = () -> AssetsListViewController
typealias AssetDetailsVcFactory = (Asset) -> AssetDetailsViewController

/// Handles the app's flow
class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    /// The navigation controller (set to window.rootViewController) where all other views are built upon
    lazy var rootVc = UINavigationController()
    
    // MARK: - Factories
    private let assetsListVcFactory: AssetsListVcFactory
    private let assetDetailsVcFactory: AssetDetailsVcFactory
    
    // MARK: - Initializer
    init(assetsListVcFactory: @escaping AssetsListVcFactory,
         assetDetailsVcFactory: @escaping AssetDetailsVcFactory) {
        self.assetsListVcFactory = assetsListVcFactory
        self.assetDetailsVcFactory = assetDetailsVcFactory
    }
    
    // MARK: - Methods
    func start(completionHandler: CoordinatorStartCompletionHandler?) {
        goToAssetsListVc()
    }
    
    /// Navigates to the assets list view controller
    private func goToAssetsListVc() {
        let assetsListVc = assetsListVcFactory()
        rootVc.pushViewController(assetsListVc, animated: false)
    }
    
    /// Navigates to the asset details view controller
    private func goToAssetDetailsVc(asset: Asset) {
        let assetDetailsVc = assetDetailsVcFactory(asset)
        rootVc.pushViewController(assetDetailsVc, animated: true)
    }
    
    /// Navigates back from the asset details view controller
    private func dismissAssetDetailsVc(from viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
}

extension AppCoordinator: AppNavigator {
    
    func navigate(to view: NavigationView) {
        switch view {
        case .assetsList:
            goToAssetsListVc()
        case .assetDetails(let asset):
            goToAssetDetailsVc(asset: asset)
        }
    }
    
    func navigateBack(from vc: UIViewController) {
        if vc is AssetDetailsViewController {
            dismissAssetDetailsVc(from: vc)
        } else {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}


