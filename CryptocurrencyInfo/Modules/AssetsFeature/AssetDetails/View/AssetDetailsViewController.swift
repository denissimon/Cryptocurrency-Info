//
//  AssetDetailsViewController.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 21.12.2020.
//

import UIKit

class AssetDetailsViewController: UIViewController, Storyboarded, Alertable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: AssetDetailsViewModel!
    private var dataSource: AssetDetailsDataSource?
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Initializer
    
    static func instantiate(viewModel: AssetDetailsViewModel) -> AssetDetailsViewController {
        let vc = Self.instantiate(from: .assetDetails)
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        prepareUI()
        
        viewModel.getProfile()
    }
    
    private func setup() {
        dataSource = viewModel.dataSource
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        refreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
        
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: AssetDetailsViewModel) {
        viewModel.data.bind(self, queue: .main) { [weak self] data in
            guard let self else { return }
            dataSource?.updateData(data)
            tableView.reloadData()
        }
        
        viewModel.makeToast.bind(self, queue: .main) { [weak self] message in
            guard !message.isEmpty else { return }
            self?.makeToast(message: message)
        }
        
        viewModel.activityIndicatorVisibility.bind(self, queue: .main) { [weak self] value in
            guard let self else { return }
            if value {
                makeToastActivity()
            } else {
                hideToastActivity()
            }
        }
    }
    
    // MARK: - Private
    
    private func prepareUI() {
        navigationItem.title = viewModel.data.value.asset?.name
        
        tableView.refreshControl = refreshControl
        
        tableView.separatorColor = .clear
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func updateData(_ sender: Any) {
        viewModel.updateData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
}

