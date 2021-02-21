//
//  FeedImageDataMapperTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 21/02/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import EssentialFeed
import XCTest

class FeedImageDataMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedImageDataMapper.map(
                    data: anyData(),
                    from: HTTPURLResponse(statusCode: code)
                )
            )
        }
    }

    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()

        XCTAssertThrowsError(
            try FeedImageDataMapper.map(
                data: emptyData,
                from: HTTPURLResponse(statusCode: 200)
            )
        )
    }

    func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)

        let result = try FeedImageDataMapper.map(
            data: nonEmptyData,
            from: HTTPURLResponse(statusCode: 200)
        )

        XCTAssertEqual(result, nonEmptyData)
    }

}
