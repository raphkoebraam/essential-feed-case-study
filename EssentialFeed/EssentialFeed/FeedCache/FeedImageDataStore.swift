//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 09/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieveData(for url: URL, completion: @escaping (Result) -> Void)
}
