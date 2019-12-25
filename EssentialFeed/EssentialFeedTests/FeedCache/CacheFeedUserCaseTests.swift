//
//  CacheFeedUserCaseTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 25/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteChacedFeedCallCount = 0
}

class CacheFeedUserCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteChacedFeedCallCount, 0)
    }
}
