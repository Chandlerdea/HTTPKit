//
//  HTTPNetworkControllerTests.swift
//  HTTPKitTests
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import HTTPKit

private struct MockModel: Codable {
    let name: String
}

private class MockController: HTTPNetworkController {
    
}

class HTTPNetworkControllerTests: XCTestCase, MockNetworkTestable {
    
    override func tearDown() {
        self.resetURLProtocol()
        super.tearDown()
    }
    
    func testThatRequestSendsSuccessfully() {
        MockURLProtocol.response = .ok
        MockURLProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "successful request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, in: self.urlSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success(let model):
                XCTAssertEqual(model.name, "chandler")
            case .failure(let error):
                XCTFail(String(describing: error))
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
    func testThatBadJSONThrowsDecodingFailureError() {
        MockURLProtocol.response = .ok
        MockURLProtocol.payload = """
        {
            "poo": "Foo"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "failure decoding json request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, in: self.urlSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success:
                XCTFail("test should fail")
            case .failure(let error):
                if case HTTP.ResponseContentError.failureDecodingResponse = error {
                    break
                } else {
                    XCTFail("Expected error \(String(describing: HTTP.ResponseContentError.failureDecodingResponse))")
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
    func testThatUnexpectedResponseCodeThrowsError() {
        MockURLProtocol.response = .created
        MockURLProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "failure decoding json request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, in: self.urlSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success:
                XCTFail("test should fail")
            case .failure(let error):
                if case HTTP.BadResponseStatusError.unexpectedStatus(let wrongStatus) = error {
                    XCTAssertEqual(wrongStatus, .created)
                } else {
                    XCTFail("Expected error \(String(describing: HTTP.ResponseContentError.failureDecodingResponse))")
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
    func testThatUnknownResponseCodeThrowsError() {
        MockURLProtocol.responseCode = 9999
        MockURLProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "failure decoding json request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, in: self.urlSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success:
                XCTFail("test should fail")
            case .failure(let error):
                if case HTTP.BadResponseStatusError.unknownResponseCode = error {
                    break
                } else {
                    XCTFail("Expected error \(String(describing: error))")
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
    func testThatRequestThrowsNoResponseStatusError() {
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "unsuccessful request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, in: self.urlSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success:
                XCTFail("exepcted failure")
            case .failure:
                break
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
    func testThatRequestWithNoResponseReturnsVoidSuccess() {
        MockURLProtocol.response = .noContent
        MockURLProtocol.payload = String()
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "no content response")
        var request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        request.method = .delete
        controller.sendRequestExpectingNoContent(request, in: self.urlSession) { (r: Result<Void, Error>) in
            switch r {
            case .success:
                break
            case .failure(let error):
                XCTFail(String(describing: error))
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }

}
