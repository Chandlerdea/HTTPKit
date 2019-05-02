//
//  HTTPRequestBuilder.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {
    
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
            let nameValue: (String, String) = header.nameAndValue
            result.addValue(nameValue.1, forHTTPHeaderField: nameValue.0)
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
        
        public func build() -> URLRequest {
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
            result.httpMethod = self.method.rawValue
            return result
        }
    }

    
}
