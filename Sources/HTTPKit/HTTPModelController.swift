//
//  HTTPModelController.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 7/19/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

public protocol HTTPModelController: HTTPNetworkController {

    func getModels<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<[ResponsePaylod], Error>) -> Void
    )
    
    func getModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    )
    
    func postModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    )
    
    func putModel<ResponsePaylod: Codable & Equatable>(
        with requestBuilder: HTTP.RequestBuilder,
        in session: URLSession,
        completion: @escaping (Result<ResponsePaylod, Error>) -> Void
    )
    
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
