//
//  Result.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

enum Result<T> {
    case done(T)
    case error((Swift.Error?, Int?)) // (error description, status code)
}
