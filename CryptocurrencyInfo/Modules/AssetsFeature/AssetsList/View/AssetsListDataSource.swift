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
    private(set) var priceCurrency: PriceCurrency = .usd
    
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
    
    func setPriceCurrency(_ priceCurrency: PriceCurrency) {
        self.priceCurrency = priceCurrency
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

        cell.name.text = data[indexPath.item].name
        cell.symbol.text = data[indexPath.item].symbol
        
        if let priceUsd = data[indexPath.item].metrics.marketData.priceUsd {
            cell.price.text = Supportive.getPriceStr(priceUsd, currency: priceCurrency)
        } else {
            cell.price.text = ""
        }
        
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
        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)

        let ret = contentOffsetMaxY > contentHeight
        if ret {
            didScrollToLastCell.notify(nil)
        }
    }
}
