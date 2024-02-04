# Cryptocurrency Info
[![Swift Version](https://img.shields.io/badge/Swift-5-F16D39.svg?style=flat)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/swift/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/denissimon/Cryptocurrency-Info/blob/master/LICENSE)

Example iOS app designed using MVVM-C and Layered Architecture. Uses Swift Concurrency.

The app shows cryptocurrency prices, charts and other info. Built with [Messari API](https://messari.io/api).

It has two MVVM modules: AssetsList and AssetDetails. The list of cryptocurrencies is loaded in batches.

Includes [unit tests](https://github.com/denissimon/Cryptocurrency-Info/tree/master/CryptocurrencyInfoTests).

<table> 
  <tr>
    <td> <img src="Screenshots/1 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/2 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/3 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
    <td> <img src="Screenshots/4 Cryptocurrency-Info - iPhone 11 - 2021-02-10.png" width = 190px></td>
  </tr>
</table>

#### Architecture concepts used here:
- [MVVM][MVVMLink]
- [Flow coordinator][FlowCoordinatorLink] implemented with protocol-based delegates
- [Dependency Injection][DIContainerLink], DIContainer
- [Data Binding][DataBindingLink] using lightweight Observable\<T\>
- [Layered Architecture][LayeredArchitectureLink]
- [Protocol-Oriented Programming][POPLink]
- Reusable and universal [NetworkService][NetworkServiceLink] based on URLSession
- [async/await][AsyncAwaitLink] with remaining the Transport Layer implemented on callbacks without changes
- [Closure-based delegation][ClosureBasedDelegationLink] using lightweight Event\<T\>
- Reusable data source for [UITableView][UITableViewDataSourceLink]
- [Multiple storyboards][MultipleStoryboardsLink]
- [Codable][CodableLink]

[MVVMLink]: https://github.com/denissimon/Cryptocurrency-Info/tree/master/CryptocurrencyInfo/Modules/AssetsFeature/AssetDetails
[FlowCoordinatorLink]: https://github.com/denissimon/Cryptocurrency-Info/tree/master/CryptocurrencyInfo/Coordinator
[DIContainerLink]: https://github.com/denissimon/Cryptocurrency-Info/blob/master/CryptocurrencyInfo/Coordinator/DIContainer/DIContainer.swift
[DataBindingLink]: https://github.com/denissimon/Cryptocurrency-Info/blob/master/CryptocurrencyInfo/Modules/AssetsFeature/AssetsList/ViewModel/AssetsListViewModel.swift
[LayeredArchitectureLink]: https://en.wikipedia.org/wiki/Multitier_architecture
[NetworkServiceLink]: https://github.com/denissimon/Cryptocurrency-Info/tree/master/CryptocurrencyInfo/Data/Network/NetworkService
[DependencyInversionPrincipleLink]: https://en.wikipedia.org/wiki/Dependency_inversion_principle
[POPLink]: https://betterprogramming.pub/difference-between-protocol-oriented-programming-pop-and-object-oriented-programming-oop-in-swift-2dc3048b4fd
[AsyncAwaitLink]: https://github.com/denissimon/Cryptocurrency-Info/tree/master/CryptocurrencyInfo/Data/Repositories
[ClosureBasedDelegationLink]: https://github.com/denissimon/Cryptocurrency-Info/blob/master/CryptocurrencyInfo/Modules/AssetsFeature/AssetsList/View/AssetsListDataSource.swift
[UITableViewDataSourceLink]: https://github.com/denissimon/Cryptocurrency-Info/blob/master/CryptocurrencyInfo/Modules/AssetsFeature/AssetsList/View/AssetsListDataSource.swift
[MultipleStoryboardsLink]: https://github.com/denissimon/Cryptocurrency-Info/tree/master/CryptocurrencyInfo/Modules/AssetsFeature
[CodableLink]: https://github.com/denissimon/Cryptocurrency-Info/blob/master/CryptocurrencyInfo/Modules/AssetsFeature/AssetDetails/Models/Profile.swift

#### Requirements:
iOS version support: 15.0+

#### Built with:
- [SwiftEvents](https://github.com/denissimon/SwiftEvents) - The easiest way to implement data binding and notifications. Includes Event\<T\> and Observable\<T\>. Has a thread-safe version.
- [Charts](https://github.com/danielgindi/Charts) - Beautiful charts for iOS/tvOS/OSX! The Apple side of the crossplatform MPAndroidChart.
- [Toast-Swift](https://github.com/scalessec/Toast-Swift) - A Swift extension that adds toast notifications to the UIView object class.
- [UAObfuscatedString](https://github.com/UrbanApps/UAObfuscatedString) - A simple category to hide sensitive strings from appearing in your binary.

The dependency manager is [CocoaPods](https://cocoapods.org). Run `pod update` to update pods.
