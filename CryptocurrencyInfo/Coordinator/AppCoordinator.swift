//
//  AppCoordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

class AppCoordinator: FlowCoordinator {
    
    // MARK: - Properties
    lazy var navigationController = UINavigationController()
    let dependencyContainer: DIContainer
        
    // MARK: - Initializer
    init(dependencyContainer: DIContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Methods
    func start(completionHandler: CoordinatorStartCompletionHandler?) {
        let mainCoordinator = dependencyContainer.makeMainCoordinator(navigationController: navigationController)
        mainCoordinator.start(completionHandler: nil)
    }
}
