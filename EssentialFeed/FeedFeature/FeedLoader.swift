//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 21/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable {}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
