//
//  HTTPModelController.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 7/19/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

/// An interface inheriting from `HTTPNetworkController` that adds CRUD methods for model objects
public protocol HTTPModelController: HTTPNetworkController {

    
    /// Makes a GET request and decodes an array of generic models
    ///
    /// - Parameters:
    ///   - requestBuilder: The `HTTP.RequestBuilder` to build the `URLRequest`
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<[ResponsePaylod], Error>`
    func getModels<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<[ResponsePaylod], Error>) -> Void
    )

    /// Makes a GET request and decodes a generic model
    ///
    /// - Parameters:
    ///   - requestBuilder: The `HTTP.RequestBuilder` to build the `URLRequest`
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<ResponsePaylod, Error>`
    func getModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    )

    /// Makes a POST request and decodes a generic model
    ///
    /// - Parameters:
    ///   - requestBuilder: The `HTTP.RequestBuilder` to build the `URLRequest`
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<ResponsePaylod, Error>`
    func postModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    )

    /// Makes a PUT request and decodes a generic model
    ///
    /// - Parameters:
    ///   - requestBuilder: The `HTTP.RequestBuilder` to build the `URLRequest`
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<ResponsePaylod, Error>`
    func putModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    )

    /// Makes a DELETE request and passes a `Result<Void, Error>`
    ///
    /// - Parameters:
    ///   - requestBuilder: The `HTTP.RequestBuilder` to build the `URLRequest`
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<Void, Error>`
    func deleteModel(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<Void, Error>) -> Void
    )

}

extension HTTPModelController {

    public func getModels<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession = URLSession.shared,
        completion: @escaping (Result<[ResponsePaylod], Error>) -> Void
    ) {
        let request: URLRequest = requestBuilder.build()
        self.sendRequest(request, in: session, completion)
    }

    public func getModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession = URLSession.shared,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    ) {
        let request: URLRequest = requestBuilder.build()
        self.sendRequest(request, in: session, completion)
    }

    public func postModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession = URLSession.shared,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    ) {
        let request: URLRequest = requestBuilder.setMethod(.post).build()
        self.sendRequest(request, in: session, completion)
    }

    public func putModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession = URLSession.shared,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    ) {
        let request: URLRequest = requestBuilder.setMethod(.put).build()
        self.sendRequest(request, in: session, completion)
    }

    public func deleteModel(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession = URLSession.shared,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let request: URLRequest = requestBuilder.setMethod(.delete).build()
        self.sendRequestExpectingNoContent(request, in: session, completion)
    }

}
