//
//  HTTPRequestBuilder+DefaultURL.swift
//  Example
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import HTTPKit

extension HTTP.RequestBuilder {
    
    static var baseUrl: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    convenience init() {
        self.init(baseURL: HTTP.RequestBuilder.baseUrl)
    }
    
}
