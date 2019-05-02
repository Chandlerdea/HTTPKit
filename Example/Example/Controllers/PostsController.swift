//
//  PostsController.swift
//  Example
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import HTTPKit

typealias PostsFetchCompletion = (Result<[Post], Error>) -> Void
typealias PostsForUserFetchCompletion = (Result<[Post], Error>) -> Void

final class PostsController: HTTPNetworkController {
    
    func getPosts(_ completion: @escaping PostsFetchCompletion) {
        let request: URLRequest = PostsRequestBuilder().posts().build()
        self.sendRequest(request) { (r: Result<[Post], Error>) in
            completion(r)
        }
    }
    
    func getPosts(for user: User, _ completion: @escaping PostsForUserFetchCompletion) {
        let request: URLRequest = PostsRequestBuilder().posts(for: user).build()
        self.sendRequest(request) { (r: Result<[Post], Error>) in
            completion(r)
        }
    }
    
}
