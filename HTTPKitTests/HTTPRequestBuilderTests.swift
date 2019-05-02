//
//  HTTPRequestBuilderTests.swift
//  TwitterClientTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import HTTPKit

class HTTPRequestBuilderTests: XCTestCase {
    
    private var baseURL: URL {
        return URL(string: "http://www.google.com")!
    }

    func testSettingsMethodWorks() {
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).setMethod(.post).build()
        
        XCTAssertEqual(request.httpMethod, "POST")
        
    }
    
    func testSettingHeaderWorks() {
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).setHeader(.contentType(.xml)).build()
        
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/xml")
        
    }
    
    func testThatSettingAuthHeaderWorks() {
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).setAuthorizationToken("123").build()
        
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer 123")
        
    }
    
    func testSettingBodayDataWorks() {
        
        let body: Data = """
        {
            "foo": "bar"
        }
        """.data(using: .utf8)!
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).setBody(body).build()
        
        XCTAssertEqual(request.httpBody, body)
        
    }
    
    func testAppendingPathComponentWorks() {
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).appendPathComponent("test").build()
        
        XCTAssertEqual(request.url?.absoluteString, "http://www.google.com/test")
        
    }
    
    func testThatAppendingOneQueryItemWorks() {
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).appendPathComponent("test").appendQueryItem(name: "name", value: "foo").build()
        
        XCTAssertEqual(request.url?.absoluteString, "http://www.google.com/test?name=foo")
    }
    
    func testThatAppendingMultipleQueryItemsWorks() {
        
        let request: URLRequest = HTTP.RequestBuilder(baseURL: self.baseURL).appendPathComponent("test")
                                                                           .appendQueryItem(name: "name", value: "foo")
                                                                           .appendQueryItem(name: "email", value: "me@me.com")
                                                                           .build()
        
        XCTAssertEqual(request.url?.absoluteString, "http://www.google.com/test?name=foo&email=me@me.com")
    }

}
