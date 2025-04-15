//
//  PriceCurrency.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 20.12.2020.
//

// https://gist.github.com/denissimon/cec7f01f89a2d4234cb2966b34726c77

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
    case USD = "$" // U.S. dollar
    case ZAR = "R" // South African rand
    
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
