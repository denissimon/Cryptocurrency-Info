//
//  AppCoordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

// Handles the app's flow
class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    lazy var navigationController = UINavigationController()
    let dependencyContainer: DIContainer
        
    // MARK: - Initializer
    init(dependencyContainer: DIContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Methods
    func start(completionHandler: CoordinatorStartCompletionHandler?) {
        // We can use MainCoordinator as a coordinator for the entire app, as well as for a first tab (with a separate UINavigationController each) or even just for an app feature such as AssetsFeature (and in this case it's better to rename MainCoordinator to the AssetsFeatureCoordinator, and to move it to the AssetsFeature folder)
        let mainCoordinator = dependencyContainer.makeMainCoordinator(navigationController: navigationController)
        mainCoordinator.start(completionHandler: nil)
    }
}
