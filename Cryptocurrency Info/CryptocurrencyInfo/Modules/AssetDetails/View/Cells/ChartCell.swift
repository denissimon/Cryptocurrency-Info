//
//  ChartCell.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 24.12.2020.
//

import UIKit
import Charts

class ChartCell: UITableViewCell {
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var chartSpinner: UIActivityIndicatorView!
}
