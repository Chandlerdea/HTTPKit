//
//  HTTPModelController.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 7/19/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

public protocol HTTPModelController: HTTPNetworkController {

    func getModels<Model: Codable & Equatable>(with requestBuilder: HTTP.RequestBuilder, in session: URLSession, completion: @escaping (Result<[Model], Error>) -> Void)
    
    func getModel<Model: Codable & Equatable>(with requestBuilder: HTTP.RequestBuilder, in session: URLSession, completion: @escaping (Result<Model, Error>) -> Void)
    
    func postModel<Model: Codable & Equatable>(_ model: Model, with requestBuilder: HTTP.RequestBuilder, in session: URLSession, completion: @escaping (Result<Model, Error>) -> Void)
    
    func putModel<Model: Codable & Equatable>(_ model: Model, with requestBuilder: HTTP.RequestBuilder, in session: URLSession, completion: @escaping (Result<Model, Error>) -> Void)
    
    func deleteModel<Model: Codable & Equatable>(_ model: Model, with requestBuilder: HTTP.RequestBuilder, in session: URLSession, completion: @escaping (Result<Void, Error>) -> Void)

}

extension HTTPModelController {

    public func getModels<Model: Codable & Equatable>(with requestBuilder: HTTP.RequestBuilder, in session: URLSession = .shared, completion: @escaping (Result<[Model], Error>) -> Void) {
        let request: URLRequest = requestBuilder.build()
        self.sendRequest(request, in: session, completion)
    }

    public func getModel<Model: Codable & Equatable>(with requestBuilder: HTTP.RequestBuilder, in session: URLSession = .shared, completion: @escaping (Result<Model, Error>) -> Void) {
        let request: URLRequest = requestBuilder.build()
        self.sendRequest(request, in: session, completion)
    }

    public func postModel<Model: Codable & Equatable>(_ model: Model, with requestBuilder: HTTP.RequestBuilder, in session: URLSession = .shared, completion: @escaping (Result<Model, Error>) -> Void) {
        let request: URLRequest = requestBuilder.setMethod(.post).build()
        self.sendRequest(request, in: session, completion)
    }

    public func putModel<Model: Codable & Equatable>(_ model: Model, with requestBuilder: HTTP.RequestBuilder, in session: URLSession = .shared, completion: @escaping (Result<Model, Error>) -> Void) {
        let request: URLRequest = requestBuilder.setMethod(.put).build()
        self.sendRequest(request, in: session, completion)
    }

    public func deleteModel<Model: Codable & Equatable>(_ model: Model, with requestBuilder: HTTP.RequestBuilder, in session: URLSession = .shared, completion: @escaping (Result<Void, Error>) -> Void) {
        let request: URLRequest = requestBuilder.setMethod(.delete).build()
        self.sendRequestExpectingNoContent(request, in: session, completion)
    }

}
