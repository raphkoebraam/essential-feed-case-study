//
//  Created by Raphael Silva on 17/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
