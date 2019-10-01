//
//  HTTP.ResponseStatusTests.swift
//  TwitterClientTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import HTTPKit

class HTTPResponseStatusTests: XCTestCase {

    func testThatHTTPResonseStatueIsCreated() {
        XCTAssertEqual(HTTP.ResponseStatus(code: 200), .ok)
        XCTAssertEqual(HTTP.ResponseStatus(code: 201), .created)
        XCTAssertEqual(HTTP.ResponseStatus(code: 202), .accepted)
        XCTAssertEqual(HTTP.ResponseStatus(code: 204), .noContent)
        XCTAssertEqual(HTTP.ResponseStatus(code: 304), .notModified)
        XCTAssertEqual(HTTP.ResponseStatus(code: 400), .badRequest)
        XCTAssertEqual(HTTP.ResponseStatus(code: 401), .unauthorized)
        XCTAssertEqual(HTTP.ResponseStatus(code: 403), .forbidden)
        XCTAssertEqual(HTTP.ResponseStatus(code: 404), .notFound)
        XCTAssertEqual(HTTP.ResponseStatus(code: 503), .error(503))
        XCTAssertNil(HTTP.ResponseStatus(code: 1000))
    }
    
    func testThatCodeIsCorrect() {
        XCTAssertEqual(HTTP.ResponseStatus.ok.code, 200)
        XCTAssertEqual(HTTP.ResponseStatus.created.code, 201)
        XCTAssertEqual(HTTP.ResponseStatus.accepted.code, 202)
        XCTAssertEqual(HTTP.ResponseStatus.noContent.code, 204)
        XCTAssertEqual(HTTP.ResponseStatus.notModified.code, 304)
        XCTAssertEqual(HTTP.ResponseStatus.badRequest.code, 400)
        XCTAssertEqual(HTTP.ResponseStatus.unauthorized.code, 401)
        XCTAssertEqual(HTTP.ResponseStatus.forbidden.code, 403)
        XCTAssertEqual(HTTP.ResponseStatus.notFound.code, 404)
        XCTAssertEqual(HTTP.ResponseStatus(code: 555)?.code, 555)
    }
    
    func testThatURLResponseStatusIsCorrect() {
        let url: URL = URL(string: "http://www.google.com")!
        
        let getRequest: URLRequest = URLRequest(url: url)
        var postRequest: URLRequest = URLRequest(url: url)
        postRequest.httpMethod = "POST"
        var deleteRequest: URLRequest = URLRequest(url: url)
        deleteRequest.httpMethod = "DELETE"
        
        let okResponse: URLResponse = HTTPURLResponse(
            url: url,
            statusCode: HTTP.ResponseStatus.ok.code,
            httpVersion: "1.1",
            headerFields: .none
        )!
        
        let createdResponse: URLResponse = HTTPURLResponse(
            url: url,
            statusCode: HTTP.ResponseStatus.created.code,
            httpVersion: "1.1",
            headerFields: .none
        )!

        let noContentResponse: URLResponse = HTTPURLResponse(
            url: url,
            statusCode: HTTP.ResponseStatus.noContent.code,
            httpVersion: "1.1",
            headerFields: .none
        )!
        
        XCTAssertEqual(okResponse.status, .ok)
        
        XCTAssertTrue(okResponse.hasValidResponseStatus(for: getRequest))
        XCTAssertFalse(createdResponse.hasValidResponseStatus(for: getRequest))
        XCTAssertTrue(createdResponse.hasValidResponseStatus(for: postRequest))
        XCTAssertTrue(noContentResponse.hasValidResponseStatus(for: deleteRequest))
        
    }

}
