//
//  AppNavigator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

// To provide even lower coupling between two view controllers. The AppCoordinator will conform to AppNavigator protocol.
protocol AppNavigator {
    func navigate(to view: NavigationView)
    func navigateBack(from vc: UIViewController)
}

enum NavigationView {
    case assetsList
    case assetDetails(asset: Asset)
}
