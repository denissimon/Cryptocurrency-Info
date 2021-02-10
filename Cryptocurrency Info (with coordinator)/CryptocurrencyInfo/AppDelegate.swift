//
//  AppDelegate.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let dependencyContainer = DependencyContainer()
    private(set) var coordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup coordinator
        coordinator = AppCoordinator(assetsListVcFactory: dependencyContainer.makeAssetsListViewController, assetDetailsVcFactory: dependencyContainer.makeAssetDetailsViewController(asset:))
        
        // Setup window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = coordinator?.rootVc
        
        // Start coordinator
        coordinator?.start(completionHandler: nil)
        
        return true
    }
}

