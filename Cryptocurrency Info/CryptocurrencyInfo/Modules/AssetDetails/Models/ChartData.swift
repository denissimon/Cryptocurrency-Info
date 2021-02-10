//
//  ChartData.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 22.12.2020.
//

struct Chart: Codable {
    let data: ChartDataClass
}

struct ChartDataClass: Codable {
    let values: [[Double]]
}
