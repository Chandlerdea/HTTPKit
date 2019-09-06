//
//  HTTPCacheControl.swift
//  HTTPKit
//
//  Created by Chandler De Angelis on 5/2/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension HTTP {

    
    /// Values that can be set as the `Cache-Control` header of a `URLRequest`
    ///
    /// - none: no-cache
    public enum CacheControlType: String {
        case none = "no-cache"
    }

}
