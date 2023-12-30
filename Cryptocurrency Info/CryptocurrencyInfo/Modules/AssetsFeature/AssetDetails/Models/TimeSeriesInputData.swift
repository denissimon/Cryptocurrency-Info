//
//  TimeSeriesInputData.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 25.12.2020.
//

import Foundation

enum TimeSeriesPeriod: String {
    case day = "day"
    case week = "week"
    case month = "month"
    case quarter = "quater"
    case halfYear = "halfYear"
    case year = "year"
}

enum TimeSeriesInterval: String {
    case oneMinute = "1m"
    case fiveMinutes = "5m"
    case fifteenMinutes = "15m"
    case thirtyMinutes = "30m"
    case hour = "1h"
    case day = "1d"
    case week = "1w"
}

struct TimeSeriesInputData {
    let asset: String
    let period: TimeSeriesPeriod
    let interval: TimeSeriesInterval
    
    // returns Date (as a formatted String) from period
    func date(dateFormat: String = "yyyy-MM-dd") -> String {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.calendar = .current
        
        switch period {
        case .day:
            dateComponent.day = -1
        case .week:
            dateComponent.day = -7
        case .month:
            dateComponent.month = -1
        case .quarter:
            dateComponent.month = -3
        case .halfYear:
            dateComponent.month = -6
        case .year:
            dateComponent.year = -1
        }
        
        if let monthAgoDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            return formatter.string(from: monthAgoDate)
        }
        
        return ""
    }
}
