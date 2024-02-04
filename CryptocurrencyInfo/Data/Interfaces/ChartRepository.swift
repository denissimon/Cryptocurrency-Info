//
//  ChartRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

protocol ChartRepository {
    typealias ChartResult = Result<Chart, NetworkError>
    
    func getChart(input: TimeSeriesInputData) async -> ChartResult
}
