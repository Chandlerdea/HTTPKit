//
//  UsersRequestBuilder.swift
//  Example
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import HTTPKit

final class UsersRequestBuilder: HTTP.RequestBuilder {
    
    func user(for post: Post) -> UsersRequestBuilder {
        let result: UsersRequestBuilder = self
        result.appendPathComponent("users")
        result.appendPathComponent(String(describing: post.userId))
        return result
    }
    
}
