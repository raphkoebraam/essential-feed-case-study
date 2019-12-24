//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 21/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
