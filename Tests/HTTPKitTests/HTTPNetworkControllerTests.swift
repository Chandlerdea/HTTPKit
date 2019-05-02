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

private final class MockProtocol: URLProtocol {
    
    static var responseCode: Int?
    static var payload: String?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let code: Int = type(of: self).responseCode {
            
            var contentLength: Int = 0
            // If the status is ok, send data
            if let payload: Data = type(of: self).payload?.data(using: .utf8), code == HTTP.ResponseStatus.ok.code {
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

private class MockController: HTTPNetworkController {
    
}

class HTTPNetworkControllerTests: XCTestCase {

    private let mockURLSession: URLSession = {
        var config: URLSessionConfiguration = .ephemeral
        config.protocolClasses = [MockProtocol.self]
        return URLSession(configuration: config)
    }()
    
    override func tearDown() {
        MockProtocol.responseCode = .none
        MockProtocol.payload = .none
        super.tearDown()
    }
    
    func testThatRequestSendsSuccessfully() {
        MockProtocol.responseCode = 200
        MockProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "successful request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
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
        MockProtocol.responseCode = 200
        MockProtocol.payload = """
        {
            "poo": "Foo"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "failure decoding json request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
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
        MockProtocol.responseCode = 201
        MockProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "failure decoding json request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
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
        MockProtocol.responseCode = 9999
        MockProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPNetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "failure decoding json request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
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
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
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

}
