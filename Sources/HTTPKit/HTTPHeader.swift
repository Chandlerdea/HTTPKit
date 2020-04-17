//
//  HTTPHeader.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    
    /// Header that can be set for a `URLRequest`
    public enum Header: Equatable {

        /// Content-Type, see [documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type)
        case contentType(ContentType)
        /// Authorization, see [documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization)
        case authorization(String)
        /// Cache-Control, see [documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)
        case cacheControl(CacheControlType)
        
        internal var nameAndValue: (name: String, value: String) {
            switch self {
            case .contentType(let type):
                return (name: "Content-Type", value: type.rawValue)
            case .authorization(let token):
                return (name: "Authorization", value: "Bearer \(token)")
            case .cacheControl(let type):
                return (name: "Cache-Control", value: type.rawValue)
            }
        }
        
    }

}

extension URLRequest {

    
    /// Adds a `HTTP.Header` to a `URLRequest`
    ///
    /// - Parameter header: The `HTTP.Header` to add to the `URLRequest`
    public mutating func add(_ header: HTTP.Header) {
        let nameValue: (String, String) = header.nameAndValue
        self.addValue(nameValue.1, forHTTPHeaderField: nameValue.0)
    }
    
}
