//
//  Storyboarded.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 15.11.2021.
//

import UIKit

enum StoryboardName: String {
    case assetsList = "AssetsList"
    case assetDetails = "AssetDetails"
}

protocol Storyboarded {
    static var className: String { get }
    static func instantiate(_ bundle: Bundle?, from storyboardName: StoryboardName) -> Self
}

extension Storyboarded where Self: UIViewController {
    static var className: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiate(_ bundle: Bundle? = nil, from storyboardName: StoryboardName) -> Self {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

