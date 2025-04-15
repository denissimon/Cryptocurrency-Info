//
//  AssetsListViewController.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import UIKit

protocol AssetsListViewControllerCoordinatorDelegate: AnyObject {
    func onAssetDetails(_ asset: Asset)
}

class AssetsListViewController: UIViewController, Storyboarded, Alertable {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var viewModel: AssetsListViewModel!
        
    private var dataSource: AssetsListDataSource?
    
    private var coordinator: AssetsListViewControllerCoordinatorDelegate?
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Initializer
    
    static func instantiate(viewModel: AssetsListViewModel, coordinator: AssetsListViewControllerCoordinatorDelegate) -> AssetsListViewController {
        let vc = Self.instantiate(from: .assetsList)
        vc.viewModel = viewModel
        vc.coordinator = coordinator
        return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        prepareUI()
        
        // Get page 1 at the app's start
        viewModel.getAssets(page: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    private func setup() {
        dataSource = viewModel.getDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        bind(to: viewModel, dataSource: dataSource)
    }
    
    private func bind(to viewModel: AssetsListViewModel, dataSource: AssetsListDataSource?) {
        viewModel.data.bind(self, queue: .main) { [weak self] data in
            self?.dataSource?.updateData(data)
            self?.tableView.reloadData()
        }
        
        viewModel.makeToast.bind(self, queue: .main) { [weak self] message in
            guard !message.isEmpty else { return }
            self?.makeToast(message: message)
        }
        
        viewModel.getAssetsCompletionHandler.bind(self) { [weak self] data in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.viewModel.setAssetsAreLoadingFromServer(false)
            }
        }
        
        viewModel.activityIndicatorVisibility.bind(self, queue: .main) { [weak self] value in
            if value {
                self?.makeToastActivity()
            } else {
                self?.hideToastActivity()
            }
        }
        
        dataSource?.didScrollToLastCell.subscribe(self) { [weak self] _ in
            guard let self = self else { return }
            if !self.viewModel.assetsAreLoadingFromServer {
                self.viewModel.getAssets(page: self.viewModel.currentPage + 1)
            }
        }
        
        dataSource?.didTapAssetDetails.subscribe(self, queue: .main) { [weak self] asset in
            self?.coordinator?.onAssetDetails(asset)
        }
    }
    
    // MARK: - Private
    
    private func prepareUI() {
        title = viewModel.screenTitle
        
        tableView.rowHeight = CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
        tableView.estimatedRowHeight = CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Back", comment: "")
        navigationItem.backBarButtonItem = backItem
        
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
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

// MARK: - UISearchBarDelegate

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
