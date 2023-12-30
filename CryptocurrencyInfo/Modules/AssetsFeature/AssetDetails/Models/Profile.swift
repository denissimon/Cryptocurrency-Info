//
//  Profile.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 22.12.2020.
//

struct Profile: Codable {
    var data: ProfileDataClass
}

struct ProfileDataClass: Codable {
    var profile: ProfileClass
}

struct ProfileClass: Codable {
    var general: ProfileGeneral
}

struct ProfileGeneral: Codable {
    var overview: ProfileOverview
}

struct ProfileOverview: Codable {
    let tagline: String?
    var projectDetails: String?
    let officialLinks: [OfficialLink]?

    enum CodingKeys: String, CodingKey {
        case tagline
        case projectDetails = "project_details"
        case officialLinks = "official_links"
    }
}

struct OfficialLink: Codable {
    let name: String?
    let link: String?
}

