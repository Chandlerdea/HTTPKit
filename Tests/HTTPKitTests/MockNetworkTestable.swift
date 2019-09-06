//
//  MockNetworkTestable.swift
//  HTTPKitTests
//
//  Created by Chandler De Angelis on 9/5/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
@testable import HTTPKit

private let mockURLSession: URLSession = {
    var config: URLSessionConfiguration = .ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}()

protocol MockNetworkTestable {
    var urlSession: URLSession { get }
    func resetURLProtocol()
}

extension MockNetworkTestable {

    var urlSession: URLSession {
        return mockURLSession
    }

    func resetURLProtocol() {
        MockURLProtocol.responseCode = .none
        MockURLProtocol.payload = .none
        MockURLProtocol.rawData = .none
    }

}
