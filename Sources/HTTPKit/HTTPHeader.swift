//
//  HTTPHeader.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    public enum Header: Equatable {
        
        case contentType(ContentType)
        case authorization(String)
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
    
    mutating func add(_ header: HTTP.Header) {
        let nameValue: (String, String) = header.nameAndValue
        self.addValue(nameValue.1, forHTTPHeaderField: nameValue.0)
    }
    
}
