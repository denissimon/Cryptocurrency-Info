//
//  AssetDetailsViewController.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 21.12.2020.
//

import UIKit
import Toast_Swift
import Charts

class AssetDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: AssetDetailsViewModel!
    
    private var dataSource: AssetDetailsDataSource?
    
    private let refreshControl = UIRefreshControl()
    
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
        
        viewModel.chartSpinnerVisibility.didChanged.addSubscriber(target: self) { (self, value) in
            self.dataSource?.setChartSpinnerVisibility(value.new)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Other
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
    }
    
    private func prepareUI() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        tableView.separatorColor = .clear
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(Constants.Other.tableCellHeight)
        
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

