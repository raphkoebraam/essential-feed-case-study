//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 27/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation
import EssentialFeed

final class FeedViewModel {
    
    private let feedLoader: FeedLoader
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func loadFeed() {
        self.isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            
            self?.isLoading = false
        }
    }
}
