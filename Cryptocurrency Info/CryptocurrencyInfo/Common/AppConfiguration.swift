//
//  AppConfiguration.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

import UAObfuscatedString

struct AppConfiguration {
    
    struct ProductionServer {
        static let messariBaseURL = "https://data.messari.io/api"
        static let messariApiKey = ""._3._1.e._7._2.a._2.e.dash.a._4.f.b.dash._4._6._6.a.dash._9._4._2._7.dash.e._1.f._0._4._8.f._7._2._4._7._4 // 31e72a2e-a4fb-466a-9427-e1f048f72474
        static let limitOnPage = 50
    }
    
    struct Other {
        static let toastDuration = 3.0
        static let tableCellDefaultHeight: Float = 58
    }
}
