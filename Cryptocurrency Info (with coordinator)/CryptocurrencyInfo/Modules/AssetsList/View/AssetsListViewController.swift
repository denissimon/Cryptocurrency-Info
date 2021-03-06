//
//  AssetsListViewController.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import UIKit
import Toast_Swift

class AssetsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = AssetsListViewModel(networkService: NetworkService())
    
    private var dataSource: AssetsListDataSource?
    
    var navigator: AppNavigator?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        prepareUI()
        
        // Get assets of page 1 at the app's start
        viewModel.getAssets(page: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    private func setup() {
        dataSource = viewModel.getDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        searchBar.delegate = self
        
        // Delegates
        viewModel.updateData.addSubscriber(target: self) { (self, data) in
            self.dataSource?.updateData(data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.showToast.addSubscriber(target: self) { (self, text) in
            if !text.isEmpty {
                DispatchQueue.main.async {
                    self.view.makeToast(text, duration: Constants.Other.toastDuration, position: .bottom)
                }
            }
        }
        
        viewModel.setPriceCurrency.addSubscriber(target: self) { (self, priceCurrency) in
            self.dataSource?.setPriceCurrency(priceCurrency)
        }
        
        dataSource?.didScrollToLastCell.addSubscriber(target: self) { (self, _) in
            if !self.viewModel.assetsAreLoadingFromServer {
                self.viewModel.getAssets(page: self.viewModel.currentPage + 1)
            }
        }
        
        dataSource?.presentDetails.addSubscriber(target: self) { (self, asset) in
            self.navigator?.navigate(to: .assetDetails(asset: asset))
        }
        
        viewModel.getAssetsCompletionHandler.addSubscriber(target: self) { (self, data) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.setAssetsAreLoadingFromServer(false)
            }
        }
        
        // Bindings
        viewModel.activityIndicatorVisibility.didChanged.addSubscriber(target: self) { (self, value) in
            DispatchQueue.main.async {
                if value.new {
                    self.view.makeToastActivity(.center)
                } else {
                    self.view.hideToastActivity()
                }
            }
        }
        
        // Other
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    private func prepareUI() {
        tableView.rowHeight = CGFloat(Constants.Other.tableCellHeight)
        tableView.estimatedRowHeight = CGFloat(Constants.Other.tableCellHeight)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        
        searchBar.sizeToFit()
    }
    
    @objc private func refreshData(_ sender: Any) {
        resetSearch()
        viewModel.clearData()
        viewModel.getAssets(page: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension AssetsListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchMode = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchAsset(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func resetSearch() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.resetSearch()
    }
}
