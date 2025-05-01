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
    
    // MARK: - Persistence
    
    lazy var settingsDBInteractor: SettingsDBInteractor = {
        // Configurable use of UserDefaults or SwiftData. Both implementations - UserDefaultsSettingsDBInteractor and SwiftDataSettingsDBInteractor - comform to the same SettingsDBInteractor protocol
        /*
        let userDefaultsAdapter = UserDefaultsAdapter()
        return UserDefaultsSettingsDBInteractor(with: userDefaultsAdapter)
        */
        let swiftDataAdapter = SwiftDataAdapter(modelContainer: SwiftDataConfiguration.container)
        return SwiftDataSettingsDBInteractor(with: swiftDataAdapter)
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
    
    func makeSettingsRepository() -> SettingsRepository {
        return DefaultSettingsRepository(settingsDBInteractor: settingsDBInteractor)
    }
    
    // MARK: - Services
    
    lazy var currencyConversionService: CurrencyConversionService = {
        DefaultCurrencyConversionService(apiInteractor: apiInteractor)
    }()
    
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
        let settingsRepository = makeSettingsRepository()
        let viewModel = AssetsListViewModel(assetRepository: assetRepository, settingsRepository: settingsRepository, currencyConversionService: currencyConversionService)
        return AssetsListViewController.instantiate(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeAssetDetailsViewController(asset: Asset) -> AssetDetailsViewController {
        let profileRepository = makeProfileRepository()
        let priceRepository = makePriceRepository()
        let viewModel = AssetDetailsViewModel(asset: asset, profileRepository: profileRepository, priceRepository: priceRepository, currencyConversionService: currencyConversionService)
        return AssetDetailsViewController.instantiate(viewModel: viewModel)
    }
}
