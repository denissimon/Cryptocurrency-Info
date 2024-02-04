//
//  DefaultChartRepository.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 18.11.2023.
//

import Foundation

class DefaultChartRepository: ChartRepository {
    
    let apiInteractor: APIInteractor
    
    init(apiInteractor: APIInteractor) {
        self.apiInteractor = apiInteractor
    }
    
    private func getChart(input: TimeSeriesInputData, completionHandler: @escaping (Result<Chart, NetworkError>) -> Void) {
        let endpoint = MessariAPI.timeSeries(data: input)
        apiInteractor.requestEndpoint(endpoint, type: Chart.self) { result in
            completionHandler(result)
        }
    }
    
    func getChart(input: TimeSeriesInputData) async -> Result<Chart, NetworkError> {
        await withCheckedContinuation { continuation in
            getChart(input: input) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
