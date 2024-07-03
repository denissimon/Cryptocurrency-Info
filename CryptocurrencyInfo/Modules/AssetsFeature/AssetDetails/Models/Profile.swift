//
//  Profile.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 22.12.2020.
//

struct Profile: Codable {
    
    struct OfficialLink: Codable {
        let name: String?
        let link: String?
    }
    
    let tagline: String?
    var projectDetails: String?
    let officialLinks: [OfficialLink]?

    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum DataKeys: String, CodingKey {
        case profile
        
        enum ProfileKeys: String, CodingKey {
            case general
            
            enum GeneralKeys: String, CodingKey {
                case overview
                
                enum OverviewKeys: String, CodingKey {
                    case tagline
                    case projectDetails = "project_details"
                    case officialLinks = "official_links"
                }
            }
        }
    }
    
    init(tagline: String?, projectDetails: String?, officialLinks: [OfficialLink]?) {
        self.tagline = tagline
        self.projectDetails = projectDetails
        self.officialLinks = officialLinks
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let profile = try data.nestedContainer(keyedBy: DataKeys.ProfileKeys.self, forKey: .profile)
        let general = try profile.nestedContainer(keyedBy: DataKeys.ProfileKeys.GeneralKeys.self, forKey: .general)
        let overview = try general.nestedContainer(keyedBy: DataKeys.ProfileKeys.GeneralKeys.OverviewKeys.self, forKey: .overview)
        tagline = try? overview.decode(String.self, forKey: .tagline)
        projectDetails = try? overview.decode(String.self, forKey: .projectDetails)
        officialLinks = try? overview.decode([OfficialLink].self, forKey: .officialLinks)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        var profile = data.nestedContainer(keyedBy: DataKeys.ProfileKeys.self, forKey: .profile)
        var general = profile.nestedContainer(keyedBy: DataKeys.ProfileKeys.GeneralKeys.self, forKey: .general)
        var overview = general.nestedContainer(keyedBy: DataKeys.ProfileKeys.GeneralKeys.OverviewKeys.self, forKey: .overview)
        try overview.encode(tagline, forKey: .tagline)
        try overview.encode(projectDetails, forKey: .projectDetails)
        try overview.encode(officialLinks, forKey: .officialLinks)
    }
}
