//
//  URLRequest+additions.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 7/12/20.
//

import Foundation

extension URLRequest {

	public mutating func setBody<T: Encodable>(_ body: T) throws {
		self.httpBody = try JSONEncoder().encode(body)
	}

	public func body<T: Decodable>() throws -> T? {
		guard let data: Data = self.httpBody else { return nil }
		return try JSONDecoder().decode(T.self, from: data)
	}

}
