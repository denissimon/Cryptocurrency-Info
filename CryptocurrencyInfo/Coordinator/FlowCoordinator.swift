//
//  FlowCoordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

public typealias CoordinatorStartCompletionHandler = () -> ()

protocol FlowCoordinator {
    var navigationController: UINavigationController { get }
    func start(completionHandler: CoordinatorStartCompletionHandler?)
}

