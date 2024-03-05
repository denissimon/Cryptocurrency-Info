//
//  PriceCurrency.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 20.12.2020.
//

enum PriceCurrency: String, CustomStringConvertible {
    case AED = "د.إ" // UAE dirham
    case ARS = "ARG$" // Argentine peso
    case AUD = "A$" // Australian dollar
    case BGN = "BGN" // Bulgarian lev
    case BHD = ".د.ب" // Bahraini dinar
    case BRL = "R$" // Brazilian real
    case CAD = "C$" // Canadian dollar
    case CHF = "CHF" // Swiss franc
    case CLP = "CLP$" // Chilean peso
    case CNH = "CNH" // Chinese renminbi
    case CNY = "¥/元" // Chinese renminbi
    case COP = "COL$" // Colombian peso
    case CZK = "Kč" // Czech koruna
    case DKK = "DKK" // Danish krone
    case EUR = "€" // Euro
    case GBP = "£" // Pound sterling
    case HKD = "HK$" // Hong Kong dollar
    case HUF = "Ft" // Hungarian forint
    case IDR = "Rp" // Indonesian rupiah
    case ILS = "₪" // Israeli new shekel
    case INR = "₹" // Indian rupee
    case JPY = "¥/円" // Japanese yen
    case KRW = "₩" // South Korean won
    case MXN = "MXN" // Mexican peso
    case MYR = "RM" // Malaysian ringgit
    case NOK = "NOK" // Norwegian krone
    case NZD = "NZ$" // New Zealand dollar
    case PEN = "S/" // Peruvian solBahraini dinar
    case PHP = "₱" // Philippine peso
    case PLN = "zł" // Polish złoty
    case RON = "L" // Romanian leu
    case RUB = "₽" // Russian ruble
    case SAR = "﷼" // Saudi riyal
    case SEK = "SEK" // Swedish krona
    case SGD = "S$" // Singapore dollar
    case THB = "฿" // Thai baht
    case TRY = "₺" // Turkish lira
    case TWD = "NT$" // New Taiwan dollar
    case ZAR = "R" // South African rand
    case USD = "$" // U.S. dollar
    
    var description: String {
        switch self {
        case .AED: return "AED"
        case .ARS: return "ARS"
        case .AUD: return "AUD"
        case .BGN: return "BGN"
        case .BHD: return "BHD"
        case .BRL: return "BRL"
        case .CAD: return "CAD"
        case .CHF: return "CHF"
        case .CLP: return "CLP"
        case .CNH: return "CNH"
        case .CNY: return "CNY"
        case .COP: return "COP"
        case .CZK: return "CZK"
        case .DKK: return "DKK"
        case .EUR: return "EUR"
        case .GBP: return "GBP"
        case .HKD: return "HKD"
        case .HUF: return "HUF"
        case .IDR: return "IDR"
        case .ILS: return "ILS"
        case .INR: return "INR"
        case .JPY: return "JPY"
        case .KRW: return "KRW"
        case .MXN: return "MXN"
        case .MYR: return "MYR"
        case .NOK: return "NOK"
        case .NZD: return "NZD"
        case .PEN: return "PEN"
        case .PHP: return "PHP"
        case .PLN: return "PLN"
        case .RON: return "RON"
        case .RUB: return "RUB"
        case .SAR: return "SAR"
        case .SEK: return "SEK"
        case .SGD: return "SGD"
        case .THB: return "THB"
        case .TRY: return "TRY"
        case .TWD: return "TWD"
        case .ZAR: return "ZAR"
        case .USD: return "USD"
        }
    }
}
