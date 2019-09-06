//
//  HTTP.Method.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        
        var validResponseStatuses: [ResponseStatus] {
            switch self {
            case .get:
                return [.ok, .notModified]
            case .post:
                return [.ok, .created]
            case .put:
                return [.ok]
            case .delete:
                return [.noContent]
            }
        }
    }
    
}

extension URLRequest {
    
    var method: HTTP.Method? {
        get {
            return self.httpMethod.flatMap(HTTP.Method.init(rawValue:))
        }
        set {
            self.httpMethod = newValue?.rawValue
        }
    }
    
}
