# URLSessionAdapter

[![Swift](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg)](https://developer.apple.com/swift/)

A Codable wrapper around URLSession for networking. Includes both APIs: async/await and callbacks. 

Supports _data_, _upload_, and _download_ URL session tasks.

Installation
------------

#### Swift Package Manager

To install URLSessionAdapter using [Swift Package Manager](https://swift.org/package-manager):

```txt
Xcode: File -> Add Packages
Enter Package URL: https://github.com/denissimon/URLSessionAdapter
```

#### CocoaPods

To install URLSessionAdapter using [CocoaPods](https://cocoapods.org), add this line to your `Podfile`:

```ruby
pod 'URLSessionAdapter', '~> 1.6'
```

#### Carthage

To install URLSessionAdapter using [Carthage](https://github.com/Carthage/Carthage), add this line to your `Cartfile`:

```ruby
github "denissimon/URLSessionAdapter"
```

#### Manually

Copy folder `URLSessionAdapter` into your project.

Usage
-----

**Defining a Codable instance:**

```swift
struct Activity: Codable {
    let id: Int?
    let name: String
    let description: String
}
```

**Defining API endpoints:**

```swift
import URLSessionAdapter

struct APIEndpoints {
    
    static let baseURL = "https://api.example.com/rest"
    static let apiKey = "api_key"
    
    static func getActivity(id: Int) -> EndpointType {
        let path = "/activities/\(id)/?api_key=\(APIEndpoints.apiKey)"        
        return Endpoint(
            method: .GET,
            baseURL: APIEndpoints.baseURL,
            path: path,
            params: nil)
    }
    
    static func createActivity(_ activity: Activity) -> EndpointType {
        let path = "/activities/?api_key=\(APIEndpoints.apiKey)"
        
        let activityData = activity.encode()
        let params = HTTPParams(httpBody: activityData, headerValues:[
        (value: "application/json", forHTTPHeaderField: "Content-Type")])
        
        return Endpoint(
            method: .POST,
            baseURL: APIEndpoints.baseURL,
            path: path,
            params: params)
    }
}
```

**Defining API methods:**

```swift
import URLSessionAdapter

class ActivityRepository {
    
    let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getActivity(id: Int) async throws -> Activity
        let endpoint = APIEndpoints.getActivity(id: id)
        return try await networkService.request(endpoint, type: Activity.self)
    }
    
    func createActivity(_ activity: Activity) async throws -> Data? {
        let endpoint = APIEndpoints.createActivity(activity)
        return try await networkService.request(endpoint)
    }
}
```

**API calls:**

```swift
let activityRepository = ActivityRepository(networkService: NetworkService())

Task {
    do {
        let activity = try await activityRepository.getActivity(id: 1) // -> Activity
        ...
    } catch {
        ...
    }
}

Task {
    do {
        // The server returns the id of the created activity
        if let data = try await activityRepository.createActivity(activity) { // -> Data?
            if let createdActivityId = Int(String(data: data, encoding: .utf8) ?? "") {
                ...
            }
        }
    } catch {
        ...
    }
}
```

```swift
let networkService = NetworkService()

// To fetch a file:
let data = try await networkService.fetchFile(url: url)
guard let image = UIImage(data: data) else {
    ...
}

// To download a file:
guard try await networkService.downloadFile(url: url, to: localUrl) else {
    ...
}

// To upload a file:
let endpoint = JSONPlaceholderAPI.uploadFile(file)
let config = RequestConfig(uploadTask: true)
let response = try await networkService.request(endpoint, config: config)
```

```swift
// To get a result with status code:
let endpoint = JSONPlaceholderAPI.createPost(post)
let response = try await networkService.requestWithStatusCode(endpoint, type: Post.self)
let post = response.result // Returned created Post
let statusCode = response.statusCode // Returned 201 status code
```

```swift
// By default, any 400-599 status code returned by the server throws a NetworkError:
do {
    // The server will return status code 404
    let response = try await networkService.requestWithStatusCode(endpoint)
    ...
} catch {
    switch error {
    case is NetworkError:
        let networkError = error as! NetworkError
        let errorDescription = networkError.error?.localizedDescription
        let errorStatusCode = networkError.statusCode // 404
        let errorDataStr = String(data: networkError.data ?? Data(), encoding: .utf8)!
        ...
    default:
        // Handling other network errors
        ...
    }
}

// Optionally, this automatic validation can be disabled globally:
networkService.autoValidation = false
do {
    // The server will return status code 404
    let response = try await networkService.requestWithStatusCode(endpoint)
    let statusCode = response.statusCode // 404
    let resultStr = String(data: response.result ?? Data(), encoding: .utf8)!
} catch {
    ...
}

// Or this automatic validation can be disabled for a given request:
do {
    // The server will return status code 404
    let config = RequestConfig(autoValidation: false)
    let response = try await networkService.requestWithStatusCode(endpoint, config: config)
    let statusCode = response.statusCode // 404
    let resultStr = String(data: response.result ?? Data(), encoding: .utf8)!
} catch {
    ...
}
```
        
More usage examples can be found in [tests](https://github.com/denissimon/URLSessionAdapter/tree/main/Tests/URLSessionAdapterTests) and [iOS-MVVM-Clean-Architecture](https://github.com/denissimon/iOS-MVVM-Clean-Architecture) where this adapter was used.

### Public methods

```swift
// async/await API

func request(_ endpoint: EndpointType, config: RequestConfig?) async throws -> Data
func request<T: Decodable>(_ endpoint: EndpointType, type: T.Type, config: RequestConfig?) async throws -> T
func fetchFile(url: URL, config: RequestConfig?) async throws -> Data?
func downloadFile(url: URL, to localUrl: URL, config: RequestConfig?) async throws -> Bool

func requestWithStatusCode(_ endpoint: EndpointType, config: RequestConfig?) async throws -> (result: Data, statusCode: Int?)
func requestWithStatusCode<T: Decodable>(_ endpoint: EndpointType, type: T.Type, config: RequestConfig?) async throws -> (result: T, statusCode: Int?)
func fetchFileWithStatusCode(url: URL, config: RequestConfig?) async throws -> (result: Data?, statusCode: Int?)
func downloadFileWithStatusCode(url: URL, to localUrl: URL, config: RequestConfig?) async throws -> (result: Bool, statusCode: Int?)

// callbacks API

func request(_ endpoint: EndpointType, config: RequestConfig?, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable?
func request<T: Decodable>(_ endpoint: EndpointType, type: T.Type, config: RequestConfig?, completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkCancellable?
func fetchFile(url: URL, config: RequestConfig?, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable?
func downloadFile(url: URL, to localUrl: URL, config: RequestConfig?, completion: @escaping (Result<Bool, NetworkError>) -> Void) -> NetworkCancellable?

func requestWithStatusCode(_ endpoint: EndpointType, config: RequestConfig?, completion: @escaping (Result<(result: Data?, statusCode: Int?), NetworkError>) -> Void) -> NetworkCancellable?
func requestWithStatusCode<T: Decodable>(_ endpoint: EndpointType, type: T.Type, config: RequestConfig?, completion: @escaping (Result<(result: T, statusCode: Int?), NetworkError>) -> Void) -> NetworkCancellable?
func fetchFileWithStatusCode(url: URL, config: RequestConfig?, completion: @escaping (Result<(result: Data?, statusCode: Int?), NetworkError>) -> Void) -> NetworkCancellable?
func downloadFileWithStatusCode(url: URL, to localUrl: URL, config: RequestConfig?, completion: @escaping (Result<(result: Bool, statusCode: Int?), NetworkError>) -> Void) -> NetworkCancellable?
```

Requirements
------------

iOS 15.0+, macOS 12.0+, tvOS 15.0+, watchOS 8.0+

License
-------

Licensed under the [MIT license](https://github.com/denissimon/URLSessionAdapter/blob/main/LICENSE)
