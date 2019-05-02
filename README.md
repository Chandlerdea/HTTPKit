# HTTPKit

A Swift framework containing constructs for interacting with APIs over the HTTP protocol.

## Motivation

`URLSession` is great, but it has some small shortcomings. Specifically, when it comes to using RESTful APIs over HTTP. For example, `URLRequest` has a `httpMethod` property of type `String`. I have found myself making a `HTTPMethod` enum so many times, I decided to take these abstractions around http conventions, and put them in a framework.

## Example

I have included an Example project showing one way of using `HTTPKit` in an app using a RESTful api. Here are some examples of the abstractions included in the framework:

### HTTP.Method
The `HTTP.Method` type is an enum that you can use directly with `URLRequest`, like this:

    request.method = .get

### HTTP.Header
The `HTTP.Header` type is an enum giving you type safe HTTP headers, like this:

    request.add(.contentType(.json))

If there are headers that you need supported, open a an issue, or contribute and add them!

### HTTP.ResponseStatus
The `HTTP.ResponseStatus` type is also an enum that gives you strong typing of status codes, so you don't need to worry about remembering what the codes mean. You can get a `HTTP.ResponseStatus` directly from a `URLResponse`, like this:

    if case .created = response?.status {
        ...
    }

There is also mapping of `HTTP.Method` to `HTTP.Response`, so you don't need to worry about making sure the response is correct for the method used in the request, like this:

    if response.hasValidResponseStatus(for: response.originalRequest) { ...

### HTTPNetworkController
`HTTPNetworkController ` is a protocol which sends a `URLRequest`, and decodes the returned json into the supplied generic type. The nice thing about this protocol is that it contains the logic for mapping the response code to the request method, and decoding the json. When using this protocol, you don't even need to worry about `HTTP.ResponseStatus`. There are examples of this being used in the example project.

### HTTP.RequestBuilder
`HTTP.RequestBuilder` is a class which uses the [builder pattern](https://en.wikipedia.org/wiki/Builder_pattern) to build your `URLRequest`s. There are examples of this class being used in the example project. Ideally you would make a subclass, and use it like this:

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


## Contributing
If you would like to contribute, fork and submit a PR! Or open Issues! I would love input from the community to make this project the best it can be.
