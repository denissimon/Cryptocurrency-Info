//
//  AssetsListDataSource.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 20.12.2020.
//

import UIKit
import SwiftEvents

class AssetsListDataSource: NSObject {
    
    private(set) var data = [Asset]()
    
    // Bindings
    let didScrollToLastCell: Event<Bool?> = Event()
    let didTapAssetDetails: Event<Asset> = Event()
    
    init(with data: [Asset]) {
        super.init()
        updateData(data)
    }
    
    func updateData(_ data: [Asset]) {
        self.data = data
    }
}

// MARK: UITableViewDataSource

extension AssetsListDataSource: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath) as! AssetCell

        let asset = data[indexPath.item]
        cell.name.text = asset.name
        cell.symbol.text = asset.symbol
        cell.price.text = asset.price.formatedAmountCustomized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: UITableViewDelegate

extension AssetsListDataSource: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapAssetDetails.notify(data[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetMaxY = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight = Float(scrollView.contentSize.height)

        let ret = contentOffsetMaxY > contentHeight
        if ret {
            didScrollToLastCell.notify(nil)
        }
    }
}
