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
        
        internal var nameAndValue: (name: String, value: String) {
            switch self {
            case .contentType(let type):
                return (name: "Content-Type", value: type.rawValue)
            case .authorization(let token):
                return (name: "Authorization", value: "Bearer \(token)")
            }
        }
        
    }
}
