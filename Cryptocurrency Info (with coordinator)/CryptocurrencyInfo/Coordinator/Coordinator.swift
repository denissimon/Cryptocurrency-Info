//
//  Coordinator.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 27.12.2020.
//

import UIKit

public typealias CoordinatorStartCompletionHandler = () -> ()

/**
 A coordinator is responsible for navigation between views
 */
protocol Coordinator {
    /// Starts the coordinator flow
    func start(completionHandler: CoordinatorStartCompletionHandler?)
}

