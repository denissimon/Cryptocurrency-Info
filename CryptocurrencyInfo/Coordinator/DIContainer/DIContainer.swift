//
//  DIContainer.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit
import URLSessionAdapter

class DIContainer {
  
    // MARK: - Network
    
    lazy var apiInteractor: APIInteractor = {
        let urlSession = URLSession.shared
        let networkService = NetworkService(urlSession: urlSession)
        return URLSessionAPIInteractor(with: networkService)
    }()
    
    // MARK: - Repositories
    
    func makeAssetRepository() -> AssetRepository {
       return DefaultAssetRepository(apiInteractor: apiInteractor)
    }
    
    func makeProfileRepository() -> ProfileRepository {
       return DefaultProfileRepository(apiInteractor: apiInteractor)
    }
    
    func makePriceRepository() -> PriceRepository {
       return DefaultPriceRepository(apiInteractor: apiInteractor)
    }
    
    // MARK: - Flow Coordinators
    
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator {
        return MainCoordinator(navigationController: navigationController, dependencyContainer: self)
    }
}

// Optionally can be placed in a separate file DIContainer+MainCoordinatorDIContainer.swift
extension DIContainer: MainCoordinatorDIContainer {
    
    // MARK: - View Controllers
    
    func makeAssetsListViewController(coordinator: AssetsListViewControllerCoordinatorDelegate) -> AssetsListViewController {
        let assetRepository = makeAssetRepository()
        let viewModel = AssetsListViewModel(assetRepository: assetRepository)
        return AssetsListViewController.instantiate(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeAssetDetailsViewController(asset: Asset) -> AssetDetailsViewController {
        let profileRepository = makeProfileRepository()
        let priceRepository = makePriceRepository()
        let viewModel = AssetDetailsViewModel(asset: asset, profileRepository: profileRepository, priceRepository: priceRepository)
        return AssetDetailsViewController.instantiate(viewModel: viewModel)
    }
}
