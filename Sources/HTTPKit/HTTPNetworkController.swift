//
//  HTTPNetworkController.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

/// Interface for sending `URLRequest`s and decoding responses
public protocol HTTPNetworkController: class {
    
    /// Sends a `URLRequest` and attempts to decode the response to generic type `T`
    ///
    /// - Parameters:
    ///   - request: The `URLReqeust` to send
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<T, Error>`
    func sendRequest<T: Decodable>(
        _ request: URLRequest,
        in session: URLSession,
        _ completion: @escaping (Result<T, Error>) -> Void
    )

    
    /// Sends a `URLRequest` that expects the response to have no content
    ///
    /// - Parameters:
    ///   - request: The `URLReqeust` to send
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<Void, Error>`
    func sendRequestExpectingNoContent(
        _ request: URLRequest,
        in session: URLSession,
        _ completion: @escaping (Result<Void, Error>) -> Void
    )
}

extension HTTPNetworkController {

    /// Sends a `URLRequest` and attempts to decode the response to generic type `T`
    ///
    /// - Parameters:
    ///   - builder: The `HTTP.RequestBuilder` that will build the `URLRequest`
    ///   - session: The `URLSession` that will send the `URLRequest`. This is used to inject a mock `URLSession`
    ///   - completion: A closure that passes `Result<T, Error>`
    public func sendRequest<T: Decodable>(
        with builder: HTTP.RequestBuilder,
        in session: URLSession = URLSession.shared,
        _ completion: @escaping (Result<T, Error>) -> Void
    ) {
        return self.sendRequest(builder.build(), in: session, completion)
    }

}

extension HTTP {
    
    public enum ResponseContentError: Error {
        case failureDecodingResponse
        case empty
    }

}

extension HTTPNetworkController {
    
    private func handleCompletion(
        _ request: URLRequest,
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?
    ) -> Result<Data, Error> {
        if let error: Error = error {
            return .failure(error)
        } else if let data: Data = data {
            guard let status: HTTP.ResponseStatus = response?.status else {
                return .failure(HTTP.BadResponseStatusError.unknownResponseCode)
            }
            guard response?.hasValidResponseStatus(for: request) == true else {
                return .failure(HTTP.BadResponseStatusError.unexpectedStatus(status))
            }
            return .success(data)
        } else {
            return .failure(HTTP.ResponseContentError.empty)
        }
    }
    
    public func sendRequest<T: Decodable>(
        _ request: URLRequest,
        in session: URLSession = URLSession.shared,
        _ completion: @escaping (Result<T, Error>) -> Void
    ) {
        let task: URLSessionTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            let result: Result<Data, Error> = self.handleCompletion(request, data, response, error)
            switch result {
            case .success(let data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let object: T = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(HTTP.ResponseContentError.failureDecodingResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func sendRequestExpectingNoContent(
        _ request: URLRequest,
        in session: URLSession = URLSession.shared,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let task: URLSessionTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            let result: Result<Data, Error> = self.handleCompletion(request, data, response, error)
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
