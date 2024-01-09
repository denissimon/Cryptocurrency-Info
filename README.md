# Cryptocurrency Info
[![Swift Version](https://img.shields.io/badge/Swift-5-F16D39.svg?style=flat)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/swift/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/denissimon/Cryptocurrency-Info/blob/master/LICENSE)

Example iOS app designed using MVVM-C and Clean Architecture. Uses Swift Concurrency.

The app shows cryptocurrency prices, charts and other info. Built with Messari API.

It has two modules: AssetsList and AssetDetails. The list of cryptocurrencies is loaded in batches.

Includes unit tests.

<table> 
  <tr>
    <td> <img src="Screenshots/1 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/2 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/3 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/4 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
  </tr>
</table>

#### Architecture concepts used here:
- MVVM
- Flow coordinator
- DIContainer
- Data Binding using lightweight Observable\<T\>
- Clean Architecture
- Dependency Inversion Principle
- Dependency Injection, protocol composition
- Reusable and universal NetworkService based on URLSession
- async-await with remaining the transport layer implemented on callbacks without changes
- Closure-based delegation using lightweight Event\<T\>
- Reusable data source for UITableView
- Multiple storyboards
- Codable

#### Requirements:
iOS version support: 15.0+

#### Built with:
- [SwiftEvents](https://github.com/denissimon/SwiftEvents) - The easiest way to implement data binding and notifications.
- [Charts](https://github.com/danielgindi/Charts) - Beautiful charts for iOS/tvOS/OSX! The Apple side of the crossplatform MPAndroidChart.
- [Toast-Swift](https://github.com/scalessec/Toast-Swift) - A Swift extension that adds toast notifications to the UIView object class.
- [UAObfuscatedString](https://github.com/UrbanApps/UAObfuscatedString) - A simple category to hide sensitive strings from appearing in your binary.

The dependency manager is [CocoaPods](https://cocoapods.org). Run `pod update` to update pods.
