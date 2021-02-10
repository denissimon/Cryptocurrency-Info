# Cryptocurrency Info
[![Swift Version](https://img.shields.io/badge/Swift-5.3-F16D39.svg?style=flat)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/swift/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/denissimon/Cryptocurrency-Info/blob/master/LICENSE)

A demo iOS app that shows cryptocurrency prices, charts and other info. Built with Messari API.

It has two modules: AssetsList and AssetDetails. The list of cryptocurrencies is loaded in batches.

There are two versions of implementation: without coordinator (MVVM) and with coordinator (MVVM-C).

<table> 
  <tr>
    <td> <img src="Screenshots/1 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/2 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/3 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/4 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
  </tr>
</table>

#### Architecture concepts:
- MVVM
- Coordinator
- Multiple Storyboards
- Dependency Injection
- Data Binding
- Event-based (pub-sub) communication between instances
- Reusable data source for UITableView
- Reusable and universal networking
- Codable

#### Built with:
- [SwiftEvents](https://github.com/denissimon/SwiftEvents) - A lightweight library for creating and observing events.
- [Charts](https://github.com/danielgindi/Charts) - Beautiful charts for iOS/tvOS/OSX! The Apple side of the crossplatform MPAndroidChart.
- [Toast-Swift](https://github.com/scalessec/Toast-Swift) - A Swift extension that adds toast notifications to the UIView object class.
- [UAObfuscatedString](https://github.com/UrbanApps/UAObfuscatedString) - A simple category to hide sensitive strings from appearing in your binary.

The dependency manager is [CocoaPods](https://cocoapods.org). Run `pod update` to update pods.
