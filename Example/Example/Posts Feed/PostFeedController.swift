//
//  PostFeedController.swift
//  Example
//
//  Created by Chandler De Angelis on 5/1/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

typealias PostsFeedCompletion = (Result<[Post], Error>) -> Void

final class PostFeedController {
    
    private let postsController: PostsController = PostsController()
    private let usersController: UsersController = UsersController()
    private let workQueue: DispatchQueue = DispatchQueue(label: "controller work queue")
    private let semophore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    func getPosts(_ completion: @escaping PostsFeedCompletion) {
        self.workQueue.async {
            var posts: [Post] = []
            self.postsController.getPosts { (r: Result<[Post], Error>) in
                switch r {
                case .success(let fetchedPosts):
                    posts = fetchedPosts
                case .failure(let error):
                    fatalError(String(describing: error))
                }
                self.semophore.signal()
            }
            self.semophore.wait()
            self.usersController.getUsers(for: posts) { (r: Result<[Post], Error>) in
                DispatchQueue.main.async {
                    completion(r)
                }
            }
        }
    }

}
