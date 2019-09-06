//
//  HTTPContentType.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    
    /// Values that can be set as the `Content-Type` header of a `URLRequest`
    ///
    /// - json: application/json
    /// - xml: application/xml
    public enum ContentType: String {
        case json = "application/json"
        case xml = "application/xml"
    }

}
