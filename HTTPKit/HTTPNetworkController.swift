//
//  HTTPNetworkController.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

public protocol HTTPNetworkController {
    func sendRequest<T: Decodable>(_ request: URLRequest, _ session: URLSession, completion: @escaping (Result<T, Error>) -> Void)
}

extension HTTP {
    
    public enum ResponseContentError: Error {
        case failureDecodingResponse
        case empty
    }

}

extension HTTPNetworkController {
    
    func handleCompletion(_ request: URLRequest, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<Data, Error> {
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
    
    func sendRequest<T: Decodable>(_ request: URLRequest, _ session: URLSession = URLSession.shared, completion: @escaping (Result<T, Error>) -> Void) {
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
    
}
