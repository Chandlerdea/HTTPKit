//
//  HTTP.MethodTests.swift
//  TwitterClientTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import HTTPKit

class HTTPMethodTests: XCTestCase {

    func testValidResponseStatusesAreCorrect() {
        XCTAssertEqual(HTTP.Method.get.validResponseStatuses, [.ok, .notModified])
        XCTAssertEqual(HTTP.Method.post.validResponseStatuses, [.ok, .created])
        XCTAssertEqual(HTTP.Method.put.validResponseStatuses, [.ok])
        XCTAssertEqual(HTTP.Method.delete.validResponseStatuses, [.noContent])
    }
    
    func testThatURLRequestHasCorrectHTTPMethod() {
        var request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        XCTAssertEqual(request.method, .get)
        request.method = .post
        XCTAssertEqual(request.method, .post)
    }

}
