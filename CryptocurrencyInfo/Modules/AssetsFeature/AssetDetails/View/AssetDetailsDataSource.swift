//
//  AssetDetailsDataSource.swift
//  CryptocurrencyInfo
//
//  Created by Denis Simon on 23.12.2020.
//

import UIKit

class AssetDetailsDataSource: NSObject {
    
    private(set) var data: Details
    
    init(with data: Details) {
        self.data = data
        super.init()
    }
    
    func updateData(_ data: Details) {
        self.data = data
    }
    
    @objc func onLinkTap(sender: UIButton){
        let linkTag = sender.tag
        
        guard let officialLinks = data.profile?.officialLinks else { return }
        guard let linkUrlString = officialLinks[linkTag].link, let url = URL(string: linkUrlString) else { return }
            
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: UITableViewDataSource

extension AssetDetailsDataSource: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else if section == 2 {
            if let officialLinks = data.profile?.officialLinks {
                return officialLinks.count
            } else {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let hatCell = tableView.dequeueReusableCell(withIdentifier: "HatCell", for: indexPath) as! HatCell

                hatCell.name.text = data.asset?.name
                hatCell.symbol.text = data.asset?.symbol
                hatCell.price.text = data.asset?.price.formatedAmountCustomized
                
                return hatCell
            
            } else if indexPath.item == 1 {
                let taglineCell = tableView.dequeueReusableCell(withIdentifier: "TaglineCell", for: indexPath) as! TaglineCell

                if let tagline = data.profile?.tagline {
                    taglineCell.tagline.text = tagline
                } else {
                    taglineCell.tagline.text = ""
                }
                
                return taglineCell
            }
        } else if indexPath.section == 1 {
            let aboutCell = tableView.dequeueReusableCell(withIdentifier: "AboutAssetCell", for: indexPath) as! AboutAssetCell

            if let about = data.profile?.projectDetails {
                aboutCell.about.text = about
            } else {
                aboutCell.about.text = ""
            }
            
            return aboutCell
        } else if indexPath.section == 2 {
            let linkCell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell

            var title = ""
            if let officialLinks = data.profile?.officialLinks, let linkName = officialLinks[indexPath.item].name {
                title = linkName
            }
            linkCell.link.setTitle(title, for: .normal)
            linkCell.link.setTitle(title, for: .highlighted)
            
            linkCell.link.addTarget(self, action: #selector(onLinkTap(sender:)), for: .touchUpInside)
            linkCell.link.tag = indexPath.row
            
            return linkCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                return 120
            } else if indexPath.item == 1 {
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                return UITableView.automaticDimension
            } else {
                return CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
            }
        } else if indexPath.section == 2 {
            return 48
        }
        return CGFloat(AppConfiguration.Other.tableCellDefaultHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 28
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return NSLocalizedString("About", comment: "")
        } else if section == 2 {
            return NSLocalizedString("Links", comment: "")
        }
        return nil
    }
}

// MARK: UITableViewDelegate

extension AssetDetailsDataSource: UITableViewDelegate {
}
