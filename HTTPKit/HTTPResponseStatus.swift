//
//  HTTP.ResponseStatus.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    enum ResponseStatus: Equatable {
        
        case ok
        case created
        case accepted
        case noContent
        case notModified
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case error(Int)
        
        init?(code: Int) {
            switch code {
            case 200:
                self = .ok
            case 201:
                self = .created
            case 202:
                self = .accepted
            case 204:
                self = .noContent
            case 304:
                self = .notModified
            case 400:
                self = .badRequest
            case 401:
                self = .unauthorized
            case 403:
                self = .forbidden
            case 404:
                self = .notFound
            case 500..<599:
                self = .error(code)
            default:
                return nil
            }
        }
        
        var code: Int {
            switch self {
            case .ok:
                return 200
            case .created:
                return 201
            case .accepted:
                return 202
            case .noContent:
                return 204
            case .notModified:
                return 304
            case .badRequest:
                return 400
            case .unauthorized:
                return 401
            case .forbidden:
                return 403
            case .notFound:
                return 404
            case .error(let code):
                return code
            }
        }
        
    }
    
}

extension HTTP {
    
    enum BadResponseStatusError: Error {
        case unexpectedStatus(ResponseStatus)
        case unknownResponseCode
    }
    
}

extension URLResponse {
    
    var status: HTTP.ResponseStatus? {
        var result: HTTP.ResponseStatus? = .none
        if let code: Int = (self as? HTTPURLResponse)?.statusCode {
            result = HTTP.ResponseStatus(code: code)
        }
        return result
    }
    
    func hasValidResponseStatus(for request: URLRequest) -> Bool {
        var result: Bool = false
        if let status: HTTP.ResponseStatus = self.status, let method: HTTP.Method = request.method {
            result = method.validResponseStatuses.contains(status)
        }
        return result
    }
    
}
