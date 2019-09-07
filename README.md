# HTTPKit
[![Travis CI](https://travis-ci.org/Chandlerdea/HTTPKit.svg?branch=master)](https://travis-ci.org/Chandlerdea/HTTPKit) ![Swift Version](https://img.shields.io/static/v1?label=Swift&message=5.0&color=brightgreen) ![Platform](https://img.shields.io/badge/platforms-iOS%2012.2%20%7C%20macOS%2010.14.4%20%7C%20tvOS%2011.2%20%7C%20watchOS%205.2-F28D00.svg)

A Swift package containing constructs for interacting with APIs over the HTTP protocol.

## Motivation

`URLSession` is great, but it has some small shortcomings. Specifically, when it comes to using RESTful APIs over HTTP. For example, `URLRequest` has a `httpMethod` property of type `String`. I have found myself making a `HTTPMethod` enum so many times, I decided to take these abstractions around http conventions, and put them in a framework.

## Installation

### Swift Package Manager

You can use the [Swift Package Manager](https://swift.org/package-manager/) to install `HTTPKit` by adding the proper description to your `Package.swift` file:
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/Chandlerdea/HTTPKit.git", from: "1.1"),
    ]
)
```

Then run `swift build` whenever you get prepared.

### Manual
Clone the repo with `git clone git@github.com:Chandlerdea/HTTPKit.git`, and drag the `Sources/HTTPKit` directory into your project

### HTTP.Method
The `HTTP.Method` type is an enum that you can use directly with `URLRequest`, like this:

```swift
request.method = .get
```

### HTTP.Header
The `HTTP.Header` type is an enum giving you type safe HTTP headers, like this:

```swift
request.add(.contentType(.json))
```

If there are headers that you need supported, open a an issue, or contribute and add them!

### HTTP.ResponseStatus
The `HTTP.ResponseStatus` type is also an enum that gives you strong typing of status codes, so you don't need to worry about remembering what the codes mean. You can get a `HTTP.ResponseStatus` directly from a `URLResponse`, like this:

```swift
if case .created = response?.status {
    ...
}
````

There is also mapping of `HTTP.Method` to `HTTP.Response`, so you don't need to worry about making sure the response is correct for the method used in the request, like this:

```swift
if response.hasValidResponseStatus(for: response.originalRequest) { ...
```

### HTTPNetworkController
`HTTPNetworkController ` is a protocol which sends a `URLRequest`, and decodes the returned json into the supplied generic type. The nice thing about this protocol is that it contains the logic for mapping the response code to the request method, validating the response, and decoding the json. When using this protocol, you don't even need to worry about `HTTP.ResponseStatus`.

```swift
final class UsersController: HTTPNetworkController {

    func getUser(for post: Post, completion: @escaping (Result<User, Error>) -> Void) {
        let request: URLRequest = UsersRequestBuilder().user(for: post).build()
        self.sendRequest(request, completion)
    }

}
```

### HTTPModelController
`HTTPModelController` is a protocol that contains basic CRUD methods for generic types, that inherits from `HTTPNetworkController`. This sets the `HTTP.Method` of the `URLRequest`, and creates and sends the `URLRequest`.

```swift
final class PostsController: HTTPModelController {

    func uploadPost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        let requestBuilder: PostsRequestBuilder().create(post)
        self.postModel(
            with: requestBuilder,
            completion: { (result: Result<Post, Error>) in
                switch result {
                case .success:
                    ...
                case .failure:
                    ...
                }
            }
        )
    }

}
```

### HTTP.RequestBuilder
`HTTP.RequestBuilder` is a class which uses the [builder pattern](https://en.wikipedia.org/wiki/Builder_pattern) to build your `URLRequest`s. There are examples of this class being used in the example project. Ideally you would make a subclass, and use it like this:

```swift
final class PostRequestBuilder: HTTP.RequestBuilder {

    func posts(for user: User) -> PostsRequestBuilder  {
        let result: PostsRequestBuilder = self
        result.appendPathComponent("posts")
        result.appendQueryItem(name: "userId", value: String(describing: user.id))
        let authToken: String = ...
        result.add(.authorization(authToken))
        return result
    }

}

let request: URLRequest = PostRequestBuilder().posts(for: user).build()
```

## Contributing
If you would like to contribute, fork and submit a PR! Or open Issues! I would love input from the community to make this project the best it can be.
