//
//  UsersController.swift
//  Example
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import HTTPKit

typealias UserForPostFetchCompletion = (Result<User, Error>) -> Void
typealias UsersForPostsFetchCompletion = (Result<[Post], Error>) -> Void

final class UsersController: HTTPNetworkController {
    
    func getUser(for post: Post, completion: @escaping UserForPostFetchCompletion) {
        let request: URLRequest = UsersRequestBuilder().user(for: post).build()
        self.sendRequest(request) { (r: Result<User, Error>) in
            completion(r)
        }
    }
    
    func getUsers(for posts: [Post], completion: @escaping UsersForPostsFetchCompletion) {
        let group: DispatchGroup = DispatchGroup()
        var result: [Post] = []
        for post in posts {
            group.enter()
            var postWithUser: Post = post
            self.getUser(for: post) { (r: Result<User, Error>) in
                switch r {
                case .success(let user):
                    postWithUser.user = user
                    result.append(postWithUser)
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
                group.leave()
            }
        }
        let notifyQueue: DispatchQueue = DispatchQueue.global()
        group.notify(queue: notifyQueue) {
            completion(.success(result))
        }
    }
    
}
