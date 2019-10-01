
//
//  HTTPModelControllerTests.swift
//  HTTPKitTests
//
//  Created by Chandler De Angelis on 9/5/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
import Combine
@testable import HTTPKit

private struct MockModel: Codable, Equatable {
    let name: String
}

private final class MockModelController: HTTPModelController {
    
}

class HTTPModelControllerTests: XCTestCase, MockNetworkTestable {

    private var requestBuilder: HTTP.RequestBuilder {
        return HTTP.RequestBuilder(baseURL: URL(string: "http://www.google.com")!)
    }

    override func tearDown() {
        self.resetURLProtocol()
        super.tearDown()
    }

    func testThatControllerGetsModels() throws {
        MockURLProtocol.response = .ok
        MockURLProtocol.payload = """
        [{
            "name": "chandler"
        }]
        """
        let controller: HTTPModelController = MockModelController()
        var expectation: XCTestExpectation = self.expectation(description: "get models")
        controller.getModels(
            with: self.requestBuilder,
            in: self.urlSession,
            completion: { (r: Result<[MockModel], Error>) in
                switch r {
                case .success(let models):
                    XCTAssertEqual(models, [MockModel(name: "chandler")])
                case .failure(let error):
                    XCTFail(String(describing: error))
                }
                expectation.fulfill()
            }
        )
        self.waitForExpectations(timeout: 1, handler: .none)

        guard #available(iOS 13.0, *) else { return }
        expectation = self.expectation(description: "get models")
        let cancel = controller
            .getModels(
                with: self.requestBuilder,
                in: self.urlSession
            )
            .sink(
                receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    expectation.fulfill()
                },
                receiveValue: { (models: [MockModel]) in
                    XCTAssertEqual(models, [MockModel(name: "chandler")])
                }
            )
        self.waitForExpectations(timeout: 1, handler: .none)
    }

    func testThatControllerGetsModel() throws {
        MockURLProtocol.response = .ok
        MockURLProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let controller: HTTPModelController = MockModelController()
        var expectation: XCTestExpectation = self.expectation(description: "get model")
        controller.getModel(
            with: self.requestBuilder,
            in: self.urlSession,
            completion: { (r: Result<MockModel, Error>) in
                switch r {
                case .success(let model):
                    XCTAssertEqual(model, MockModel(name: "chandler"))
                case .failure(let error):
                    XCTFail(String(describing: error))
                }
                expectation.fulfill()
            }
        )
        self.waitForExpectations(timeout: 1, handler: .none)

        guard #available(iOS 13.0, *) else { return }
        expectation = self.expectation(description: "get model")
        let cancel = controller
            .getModel(
                with: self.requestBuilder,
                in: self.urlSession
            )
            .sink(
                receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    expectation.fulfill()
                },
                receiveValue: { (model: MockModel) in
                    XCTAssertEqual(model, MockModel(name: "chandler"))
                }
            )
        self.waitForExpectations(timeout: 1, handler: .none)
    }

    func testThatControllerPostsModel() throws {
        MockURLProtocol.response = .created
        MockURLProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let model: MockModel = MockModel(name: "chandler")
        let controller: HTTPModelController = MockModelController()
        var expectation: XCTestExpectation = self.expectation(description: "post model")
        controller.postModel(
            with: self.requestBuilder,
            in: self.urlSession,
            completion: { (r: Result<MockModel, Error>) in
                switch r {
                case .success(let createdModel):
                    XCTAssertEqual(model, createdModel)
                case .failure(let error):
                    XCTFail(String(describing: error))
                }
                expectation.fulfill()
            }
        )
        self.waitForExpectations(timeout: 1, handler: .none)

        guard #available(iOS 13.0, *) else { return }
        expectation = self.expectation(description: "post model")
        let cancel = controller
            .postModel(
                with: self.requestBuilder,
                in: self.urlSession
            )
            .sink(
                receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    expectation.fulfill()
                },
                receiveValue: { (model: MockModel) in
                    XCTAssertEqual(model, MockModel(name: "chandler"))
                }
            )
        self.waitForExpectations(timeout: 1, handler: .none)
    }

    func testThatControllerPutsModel() throws {
        MockURLProtocol.response = .ok
        MockURLProtocol.payload = """
        {
            "name": "chandler"
        }
        """
        let model: MockModel = MockModel(name: "carter")
        let controller: HTTPModelController = MockModelController()
        var expectation: XCTestExpectation = self.expectation(description: "put model")
        controller.putModel(
            with: self.requestBuilder,
            in: self.urlSession,
            completion: { (r: Result<MockModel, Error>) in
                switch r {
                case .success(let updatedModel):
                    XCTAssertNotEqual(updatedModel, model)
                    XCTAssertEqual(updatedModel.name, "chandler")
                case .failure(let error):
                    XCTFail(String(describing: error))
                }
                expectation.fulfill()
            }
        )
        self.waitForExpectations(timeout: 1, handler: .none)

        guard #available(iOS 13.0, *) else { return }
        expectation = self.expectation(description: "put model")
        let cancel = controller
            .putModel(
                with: self.requestBuilder,
                in: self.urlSession
            )
            .sink(
                receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    expectation.fulfill()
                },
                receiveValue: { (updatedModel: MockModel) in
                    XCTAssertNotEqual(updatedModel, model)
                    XCTAssertEqual(updatedModel.name, "chandler")
                }
            )
        self.waitForExpectations(timeout: 1, handler: .none)
    }

    func testThatControllerDeletesModel() throws {
        MockURLProtocol.response = .noContent
        let controller: HTTPModelController = MockModelController()
        var expectation: XCTestExpectation = self.expectation(description: "delete model")
        controller.deleteModel(
            with: self.requestBuilder,
            in: self.urlSession,
            completion: { (r: Result<Void, Error>) in
                switch r {
                case .success:
                    break
                case .failure(let error):
                    XCTFail(String(describing: error))
                }
                expectation.fulfill()
            }
        )
        self.waitForExpectations(timeout: 1, handler: .none)

        guard #available(iOS 13.0, *) else { return }
        expectation = self.expectation(description: "delete model")
        let cancel = controller
            .deleteModel(
                with: self.requestBuilder,
                in: self.urlSession
            )
            .sink(
                receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    switch completion {
                    case .failure(let error):
                        XCTFail("Publisher should not have failed: \(error)")
                    case .finished:
                        break
                    }
                    expectation.fulfill()
                },
                receiveValue: {}
            )
        self.waitForExpectations(timeout: 1, handler: .none)
    }

}
