//
//  MockURLProtocol.swift
//  HTTPKitTests
//
//  Created by Chandler De Angelis on 9/5/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
@testable import HTTPKit

final class MockURLProtocol: URLProtocol {
    
    static var responseCode: Int?
    static var response: HTTP.ResponseStatus? {
        get {
            return self.responseCode.flatMap(HTTP.ResponseStatus.init(code:))
        }
        set {
            self.responseCode = newValue?.code
        }
    }
    static var payload: String?
    static var rawData: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let code: Int = type(of: self).responseCode {
            
            var contentLength: Int = 0
            if let payload: Data = type(of: self).payload?.data(using: .utf8) {
                contentLength = payload.count
                self.client?.urlProtocol(self, didLoad: payload)
            }
            let response: HTTPURLResponse
            if let status: HTTP.ResponseStatus = HTTP.ResponseStatus(code: code) {
                response = HTTPURLResponse(
                    url: self.request.url!,
                    statusCode: status.code,
                    httpVersion: "1.1",
                    headerFields: [
                        "Content-Length": String(describing: contentLength),
                        "Content-Type": "application/json; charset=utf-8"
                    ]
                )!
            } else {
                response = HTTPURLResponse(
                    url: self.request.url!,
                    statusCode: code,
                    httpVersion: "1.1",
                    headerFields: [
                        "Content-Length": String(describing: contentLength),
                        "Content-Type": "application/json; charset=utf-8"
                    ]
                )!
            }
            self.client?.urlProtocol(
                self,
                didReceive: response as URLResponse,
                cacheStoragePolicy: .notAllowed
            )
        } else {
            let nsError: NSError = NSError(domain: "com.HTTPKitTests", code: 0, userInfo: .none)
            self.client?.urlProtocol(self, didFailWithError: nsError)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
