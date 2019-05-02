//
//  PostsRequestBuilder.swift
//  Example
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import HTTPKit

final class PostsRequestBuilder: HTTP.RequestBuilder {
    
    func posts() -> PostsRequestBuilder {
        let result: PostsRequestBuilder = self
        result.appendPathComponent("posts")
        return result
    }
    
    func posts(for user: User) -> PostsRequestBuilder  {
        let result: PostsRequestBuilder = self
        result.appendPathComponent("posts")
        result.appendQueryItem(name: "userId", value: String(describing: user.id))
        return result
    }
    
}
