//
//  AppConfiguration.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 19.12.2020.
//

struct AppConfiguration {
    
    struct ProductionServer {
        static let messariBaseURL = "https://data.messari.io/api"
        static let messariApiKey = "".J.r.v.c.K.e.Q.O.s.B._6._2.y._9.I.D.O.J.q.C.j.j.R.g.G.h.q.A.w.plus.f.P.r.G.I.Q.Q.u._7.z.L.i._2.X.x.o._3.Z
 // JrvcKeQOsB62y9IDOJqCjjRgGhqAw+fPrGIQQu7zLi2Xxo3Z
        static let limitOnPage = 50
    }
    
    struct Settings {
        /// If there is a stored value in the local DB, then selectedCurrency is updated when the app starts
        static var selectedCurrency: Currency = .USD
    }
    
    struct Other {
        static let toastDuration = 3.0
        static let tableCellDefaultHeight: Float = 58
    }
}
