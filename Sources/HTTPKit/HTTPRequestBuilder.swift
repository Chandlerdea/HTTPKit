//
//  HTTPRequestBuilder.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    /**
        A base class that uses the [builder pattern](https://en.wikipedia.org/wiki/Builder_pattern) to build and create `URLRequest`s.
        This class is meant to be subclassed, and the subclasses should add convenience methods that call this base class's methods to configure the correct `URLRequest`.
        When calling the methods, they are meant to be chained together, with the last call being `build()`. You can find an example of subclassing this in the [README](https://github.com/Chandlerdea/HTTPKit).
    */
    open class RequestBuilder {
        
        // MARK: - Properties
        
        private var components: [String]
        private var queryItems: [URLQueryItem]
        private var body: Data?
        private var headers: [Header]
        private var method: Method
        private var baseURL: URL
        
        // MARK: - Init
        
        public init(baseURL: URL) {
            self.baseURL = baseURL
            self.components = []
            self.queryItems = []
            self.method = .get
            self.headers = [
                .contentType(.json)
            ]
        }
        
        // MARK: - Functions
        
        private func addHeader(_ header: Header, to request: URLRequest) -> URLRequest {
            var result: URLRequest = request
            result.add(header)
            return result
        }
        
        @discardableResult
        public func setMethod(_ method: Method) -> RequestBuilder {
            let result: RequestBuilder = self
            result.method = method
            return result
        }
        
        @discardableResult
        public func setHeader(_ header: Header) -> RequestBuilder {
            let result: RequestBuilder = self
            if let index: Int = self.headers.firstIndex(where: { $0.nameAndValue.name == header.nameAndValue.name }) {
                result.headers[index] = header
            } else {
                result.headers.append(header)
            }
            return result
        }
        
        @discardableResult
        public func setAuthorizationToken(_ token: String) -> RequestBuilder {
            let result: RequestBuilder = self
            result.setHeader(.authorization(token))
            return result
        }
        
        @discardableResult
        public func setBody(_ body: Data) -> RequestBuilder {
            let result: RequestBuilder = self
            result.body = body
            return result
        }

        @discardableResult
        public func setPathComponents(_ comps: [String]) -> RequestBuilder {
            let result: RequestBuilder = self
            result.components = comps
            return result
        }

        @discardableResult
        public func appendPathComponent(_ comp: String) -> RequestBuilder {
            let result: RequestBuilder = self
            result.components.append(comp)
            return result
        }
        
        @discardableResult
        public func appendQueryItem(name: String, value: String) -> RequestBuilder {
            let result: RequestBuilder = self
            let item: URLQueryItem = URLQueryItem(name: name, value: value)
            result.queryItems.append(item)
            return result
        }

        @discardableResult
        public func post(with body: Data) -> RequestBuilder {
            
            self.setMethod(.post)
            self.setBody(body)
            
            return self
        }
        
        @discardableResult
        public func put(with body: Data) -> RequestBuilder {
            
            self.setMethod(.put)
            self.setBody(body)
            
            return self
        }
        
        open func build() -> URLRequest {
            var components: URLComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false)!
            for comp in self.components {
                components.path += "/\(comp)"
            }
            if self.queryItems.isEmpty == false {
                components.queryItems = self.queryItems
            }
            var result: URLRequest = URLRequest(url: components.url!)
            result.httpBody = self.body
            for header in self.headers {
                result = self.addHeader(header, to: result)
            }
            result.method = self.method
            return result
        }
    }

    
}
