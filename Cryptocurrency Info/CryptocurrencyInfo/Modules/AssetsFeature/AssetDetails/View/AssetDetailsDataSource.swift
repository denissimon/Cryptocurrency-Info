//
//  AssetDetailsDataSource.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.12.2020.
//

import UIKit
import SwiftEvents
import Charts

class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
    fileprivate var dateFormatter: DateFormatter?

    convenience init(dateFormatter: DateFormatter) {
        self.init()
        self.dateFormatter = dateFormatter
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter else { return "" }
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}

class AssetDetailsDataSource: NSObject {
    
    var data: Details {
        didSet {
            if data.chartData != nil {
                setChartData()
            }
        }
    }
    
    var chartEntries = [ChartDataEntry]()
    var xValuesNumberFormatter: ChartXAxisFormatter!
    
    private(set) var priceCurrency: PriceCurrency = .usd
    
    private(set) var chartSpinnerVisibility = false
    
    init(with data: Details) {
        self.data = data
        super.init()
    }
    
    func updateData(_ data: Details) {
        self.data = data
    }
    
    func setPriceCurrency(_ priceCurrency: PriceCurrency) {
        self.priceCurrency = priceCurrency
    }
    
    func setChartSpinnerVisibility(_ value: Bool) {
        chartSpinnerVisibility = value
    }
    
    @objc func onButtonTap(sender: UIButton){
        let buttonTag = sender.tag
        
        guard let officialLinks = data.profile?.data.profile.general.overview.officialLinks else {
            return
        }
        
        guard let linkUrlString = officialLinks[buttonTag].link, let url = URL(string: linkUrlString) else {
            return
        }
            
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func setChartData() {
        // Define chart xValues formatter
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd MMM"
        xValuesNumberFormatter = ChartXAxisFormatter(dateFormatter: dateFormatter)
        xValuesNumberFormatter.dateFormatter = dateFormatter // e.g. "27 Dec"
        
        // Define chart entries
        chartEntries.removeAll()
        for value in data.chartData!.data.values {
            let timeInterval = value[0]
            let xValue = timeInterval / 1000 // timestamp
            var yValue = Double() // close price
            if value[1] < 1.0 {
                yValue = value[1].round(to: 4)
            } else if value[1] >= 1.0 && value[1] < 10.0 {
                    yValue = value[1].round(to: 2)
            } else {
                yValue = value[1].round(to: 0)
            }
            let entry = ChartDataEntry(x: xValue, y: yValue)
            chartEntries.append(entry)
        }
        if chartEntries.count > 0 { // for reliability
            if let priceUsd = data.asset?.metrics.marketData.priceUsd {
                if priceUsd < 1.0 {
                    chartEntries[chartEntries.count-1].y = priceUsd.round(to: 4)
                } else if priceUsd >= 1.0 && priceUsd < 10.0 {
                    chartEntries[chartEntries.count-1].y = priceUsd.round(to: 2)
                } else {
                    chartEntries[chartEntries.count-1].y = priceUsd.round(to: 0)
                }
            }
        }
    }
}

// MARK: UITableViewDataSource

extension AssetDetailsDataSource: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            if let officialLinks = data.profile?.data.profile.general.overview.officialLinks {
                return officialLinks.count
            } else {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let hatCell = tableView.dequeueReusableCell(withIdentifier: "HatCell", for: indexPath) as! HatCell

                hatCell.name.text = data.asset?.name
                hatCell.symbol.text = data.asset?.symbol
                
                if let priceUsd = data.asset?.metrics.marketData.priceUsd {
                    hatCell.price.text = Supportive.getPriceStr(priceUsd, currency: priceCurrency)
                } else {
                    hatCell.price.text = ""
                }
                
                return hatCell
            
            } else if indexPath.item == 1 {
                let taglineCell = tableView.dequeueReusableCell(withIdentifier: "TaglineCell", for: indexPath) as! TaglineCell

                if let tagline = data.profile?.data.profile.general.overview.tagline {
                    taglineCell.tagline.text = tagline
                } else {
                    taglineCell.tagline.text = ""
                }
                
                return taglineCell
            }
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                let chartCell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
                
                if chartSpinnerVisibility {
                    chartCell.chartSpinner.startAnimating()
                } else {
                    chartCell.chartSpinner.stopAnimating()
                }
                
                chartCell.chartView.leftAxis.enabled = false
                chartCell.chartView.rightAxis.enabled = true
                
                if xValuesNumberFormatter != nil {
                    chartCell.chartView.xAxis.valueFormatter = xValuesNumberFormatter
                }
                chartCell.chartView.xAxis.centerAxisLabelsEnabled = false
                chartCell.chartView.xAxis.setLabelCount(6, force: true)
                chartCell.chartView.xAxis.labelPosition = .bottom
                chartCell.chartView.xAxis.drawLabelsEnabled = true
                chartCell.chartView.xAxis.drawLimitLinesBehindDataEnabled = true
                chartCell.chartView.xAxis.avoidFirstLastClippingEnabled = true
                
                chartCell.chartView.legend.form = .none
                chartCell.chartView.legend.textColor = .clear
                chartCell.chartView.legend.drawInside = true
                
                let dataSet = LineChartDataSet(entries: chartEntries)
                dataSet.mode = .cubicBezier
                dataSet.lineWidth = 2.0
                dataSet.drawCirclesEnabled = true
                dataSet.circleRadius = 2.0
                dataSet.drawFilledEnabled = true
                dataSet.drawValuesEnabled = false
                chartCell.chartView.data = LineChartData(dataSet: dataSet)
                
                chartCell.chartView.delegate = self
                
                return chartCell
            }
        } else if indexPath.section == 2 {
            let aboutCell = tableView.dequeueReusableCell(withIdentifier: "AboutAssetCell", for: indexPath) as! AboutAssetCell

            if let about = data.profile?.data.profile.general.overview.projectDetails {
                aboutCell.about.text = about
            } else {
                aboutCell.about.text = ""
            }
            
            return aboutCell
        } else if indexPath.section == 3 {
            let linkCell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell

            var title = ""
            if let officialLinks = data.profile?.data.profile.general.overview.officialLinks, let linkName = officialLinks[indexPath.item].name {
                title = linkName
            }
            linkCell.link.setTitle(title, for: .normal)
            linkCell.link.setTitle(title, for: .highlighted)
            
            linkCell.link.addTarget(self, action: #selector(onButtonTap(sender:)), for: .touchUpInside)
            linkCell.link.tag = indexPath.row
            
            return linkCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                return 120
            } else if indexPath.item == 1 {
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 1 {
            return 230
        } else if indexPath.section == 2 {
            if indexPath.item == 0 {
                return UITableView.automaticDimension
            } else {
                return CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
            }
        } else if indexPath.section == 3 {
            return 48
        }
        return CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 28
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "Chart"
        } else if section == 2 {
            return "About"
        } else if section == 3 {
            return "Links"
        }
        return nil
    }
}

// MARK: UITableViewDelegate

extension AssetDetailsDataSource: UITableViewDelegate {
}

// MARK: - ChartViewDelegate

extension AssetDetailsDataSource: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.data?.setDrawValues(true)
    }
}
