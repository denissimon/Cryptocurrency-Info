//
//  AssetDetailsViewController.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 21.12.2020.
//

import UIKit
import Toast_Swift
import Charts

class AssetDetailsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        if let asset = dataSource?.data.asset {
            viewModel.getProfile(asset: asset.symbol)
            viewModel.getChart(input: TimeSeriesInputData(asset: asset.symbol, period: viewModel.chartPeriod, interval: viewModel.chartInterval))
        }
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
        
        viewModel.showToast.bind(self, queue: .main) { [weak self] text in
            if !text.isEmpty {
                self?.view.makeToast(text, duration: AppConfiguration.Other.toastDuration, position: .bottom)
            }
        }
        
        viewModel.priceCurrency.bind(self) { [weak self] priceCurrency in
            self?.dataSource?.setPriceCurrency(priceCurrency)
        }
        
        viewModel.activityIndicatorVisibility.bind(self, queue: .main) { [weak self] value in
            if value {
                self?.view.makeToastActivity(.center)
            } else {
                self?.view.hideToastActivity()
            }
        }
        
        viewModel.chartSpinnerVisibility.bind(self, queue: .main) { [weak self] value in
            self?.dataSource?.setChartSpinnerVisibility(value)
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Private
    
    private func prepareUI() {
        if let asset = dataSource?.data.asset {
            self.navigationItem.title = asset.name
        }
        
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
    
    private func resetChartZoom() {
        let chartView = self.view.viewWithTag(10) as? LineChartView
        chartView?.zoomToCenter(scaleX: 0, scaleY: 0)
    }
    
    @objc private func updateData(_ sender: Any) {
        resetChartZoom()
        if let asset = dataSource?.data.asset {
            viewModel.getPrice(asset: asset.symbol)
            viewModel.getProfile(asset: asset.symbol)
            viewModel.getChart(input: TimeSeriesInputData(asset: asset.symbol, period: viewModel.chartPeriod, interval: viewModel.chartInterval))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onPeriodSegmentedControlChanged(_ sender: UISegmentedControl) {
        resetChartZoom()
        viewModel.onPeriodSegmentedControlChanged(sender.selectedSegmentIndex)
    }
}

