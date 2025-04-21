//
//  Currency.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 20.12.2020.
//

// https://gist.github.com/denissimon/cec7f01f89a2d4234cb2966b34726c77

enum Currency: String, Codable, CustomStringConvertible, CaseIterable {
    /// UAE dirham
    case AED = "د.إ"
    /// Argentine peso
    case ARS = "ARG$"
    /// Australian dollar
    case AUD = "A$"
    /// Bulgarian lev
    case BGN = "BGN"
    /// Bahraini dinar
    case BHD = ".د.ب"
    /// Brazilian real
    case BRL = "R$"
    /// Canadian dollar
    case CAD = "C$"
    /// Swiss franc
    case CHF = "CHF"
    /// Chilean peso
    case CLP = "CLP$"
    /// Chinese renminbi
    case CNH = "CNH"
    /// Chinese renminbi
    case CNY = "¥/元"
    /// Colombian peso
    case COP = "COL$"
    /// Czech koruna
    case CZK = "Kč"
    /// Danish krone
    case DKK = "DKK"
    /// Euro
    case EUR = "€"
    /// Pound sterling
    case GBP = "£"
    /// Hong Kong dollar
    case HKD = "HK$"
    /// Hungarian forint
    case HUF = "Ft"
    /// Indonesian rupiah
    case IDR = "Rp"
    /// Israeli new shekel
    case ILS = "₪"
    /// Indian rupee
    case INR = "₹"
    /// Japanese yen
    case JPY = "¥/円"
    /// South Korean won
    case KRW = "₩"
    /// Mexican peso
    case MXN = "MXN"
    /// Malaysian ringgit
    case MYR = "RM"
    /// Norwegian krone
    case NOK = "NOK"
    /// New Zealand dollar
    case NZD = "NZ$"
    /// Peruvian solBahraini dinar
    case PEN = "S/"
    /// Philippine peso
    case PHP = "₱"
    /// Polish złoty
    case PLN = "zł"
    /// Romanian leu
    case RON = "L"
    /// Russian ruble
    case RUB = "₽"
    /// Saudi riyal
    case SAR = "﷼"
    /// Swedish krona
    case SEK = "SEK"
    /// Singapore dollar
    case SGD = "S$"
    /// Thai baht
    case THB = "฿"
    /// Turkish lira
    case TRY = "₺"
    /// New Taiwan dollar
    case TWD = "NT$"
    /// U.S. dollar
    case USD = "$"
    /// South African rand
    case ZAR = "R"
    
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
        case .USD: return "USD"
        case .ZAR: return "ZAR"
        }
    }
    
    var symbol: String {
        switch self {
        case .AED: return "د.إ"
        case .ARS: return "$"
        case .AUD: return "$"
        case .BGN: return "лв."
        case .BHD: return ".د.ب"
        case .BRL: return "R$"
        case .CAD: return "$"
        case .CHF: return "CHF"
        case .CLP: return "$"
        case .CNH: return "¥"
        case .CNY: return "¥"
        case .COP: return "$"
        case .CZK: return "Kč"
        case .DKK: return "kr."
        case .EUR: return "€"
        case .GBP: return "£"
        case .HKD: return "HK$"
        case .HUF: return "Ft"
        case .IDR: return "Rp"
        case .ILS: return "₪"
        case .INR: return "₹"
        case .JPY: return "¥"
        case .KRW: return "₩"
        case .MXN: return "$"
        case .MYR: return "RM"
        case .NOK: return "kr"
        case .NZD: return "$"
        case .PEN: return "S/"
        case .PHP: return "₱"
        case .PLN: return "zł"
        case .RON: return "RON"
        case .RUB: return "₽"
        case .SAR: return "ر.س.‏"
        case .SEK: return "kr"
        case .SGD: return "$"
        case .THB: return "฿"
        case .TRY: return "₺"
        case .TWD: return "$"
        case .USD: return "$"
        case .ZAR: return "R"
        }
    }
    
    var local: String {
        switch self {
        case .AED: return "ar_AE"
        case .ARS: return "es_AR"
        case .AUD: return "en_AU"
        case .BGN: return "bg_BG"
        case .BHD: return "ar_BH"
        case .BRL: return "pt_BR"
        case .CAD: return "en_CA"
        case .CHF: return "de_CH"
        case .CLP: return "es_CL"
        case .CNH: return "en_CN"
        case .CNY: return "en_CN"
        case .COP: return "es_CO"
        case .CZK: return "cs_CZ"
        case .DKK: return "da_DK"
        case .EUR: return "de_DE"
        case .GBP: return "en_GB"
        case .HKD: return "zh_HK"
        case .HUF: return "hu_HU"
        case .IDR: return "id_ID"
        case .ILS: return "he_IL"
        case .INR: return "en_IN"
        case .JPY: return "ja_JP"
        case .KRW: return "ko_KR"
        case .MXN: return "es_MX"
        case .MYR: return "ms_MY"
        case .NOK: return "nb_NO"
        case .NZD: return "en_NZ"
        case .PEN: return "es_PE"
        case .PHP: return "en_PH"
        case .PLN: return "pl_PL"
        case .RON: return "ro_RO"
        case .RUB: return "ru_RU"
        case .SAR: return "ar_SA"
        case .SEK: return "sv_SE"
        case .SGD: return "en_SG"
        case .THB: return "th_TH"
        case .TRY: return "tr_TR"
        case .TWD: return "en_TW"
        case .USD: return "en_US"
        case .ZAR: return "af_ZA"
        }
    }
}
