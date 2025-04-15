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
        dataSource = viewModel.getDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        refreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
        
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: AssetDetailsViewModel) {
        viewModel.data.bind(self, queue: .main) { [weak self] data in
            self?.dataSource?.updateData(data)
            self?.tableView.reloadData()
        }
        
        viewModel.makeToast.bind(self, queue: .main) { [weak self] message in
            guard !message.isEmpty else { return }
            self?.makeToast(message: message)
        }
        
        viewModel.activityIndicatorVisibility.bind(self, queue: .main) { [weak self] value in
            if value {
                self?.makeToastActivity()
            } else {
                self?.hideToastActivity()
            }
        }
    }
    
    // MARK: - Private
    
    private func prepareUI() {
        navigationItem.title = viewModel.data.value.asset?.name
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
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

