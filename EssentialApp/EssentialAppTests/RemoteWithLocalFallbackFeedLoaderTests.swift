//
//  RemoteWithLocalFallbackFeedLoaderTests.swift
//  EssentialAppTests
//
//  Created by Raphael Silva on 16/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedLoaderWithFallbackComposite {
    
    init(primary: FeedLoader, fallback: FeedLoader) {
        
    }
}

class FeedLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversRemoteFeedOnRemoteSuccess() {
        let primaryLoader = LoaderStub()
        let fallbackLoader = LoaderStub()
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(feed):
                XCTAssertEqual(receivedFeed, remoteFeed)
            case .failure:
                XCTFail("Expected successful load feed result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private class LoaderStub: FeedLoader {
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {}
    }
}
