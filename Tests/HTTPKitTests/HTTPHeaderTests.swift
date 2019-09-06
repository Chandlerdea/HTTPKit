//
//  HTTPHeaderTests.swift
//  TwitterClientTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import HTTPKit

class HTTPHeaderTests: XCTestCase {

    func testThatNameAndValueIsCorrect() {
        XCTAssertEqual(HTTP.Header.contentType(.json).nameAndValue.0, "Content-Type")
        XCTAssertEqual(HTTP.Header.contentType(.json).nameAndValue.1, "application/json")
    }
    
    func testThatHeaderIsSet() {
        var request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        request.add(.contentType(.json))
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
        request.add(.cacheControl(.none))
        XCTAssertEqual(request.allHTTPHeaderFields?["Cache-Control"], "no-cache")
    }

}
