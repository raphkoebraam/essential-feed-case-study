//
//  ImageCommentsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 21/02/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import EssentialFeed
import XCTest

class ImageCommentsMapperTests: XCTestCase {

    func test_map_deliversErrorOnNon2xxHTTPResponse() throws {
        let jsonData = makeItemsJSONData(with: [])

        let samples = [199, 150, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(
                    data: jsonData,
                    from: HTTPURLResponse(
                        statusCode: code
                    )
                )
            )
        }
    }

    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)

        let samples = [200, 201, 250, 280, 299]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(
                    data: invalidJSON,
                    from: HTTPURLResponse(
                        statusCode: code
                    )
                )
            )
        }
    }

    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSONData(with: [])

        let samples = [200, 201, 250, 280, 299]

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(
                data: emptyListJSON,
                from: HTTPURLResponse(
                    statusCode: code
                )
            )

            XCTAssertEqual(result, [])
        }
    }

    func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username")

        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            username: "another username")

        let json = makeItemsJSONData(with: [item1.json, item2.json])
        let samples = [200, 201, 250, 280, 299]

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(
                data: json,
                from: HTTPURLResponse(
                    statusCode: code
                )
            )

            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }

    // MARK: - Helpers

    private func makeItem(
        id: UUID,
        message: String,
        createdAt: (date: Date, iso8601String: String),
        username: String
    ) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(
            id: id,
            message: message,
            createdAt: createdAt.date,
            username: username
        )
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ].compactMapValues { $0 }

        return (item, json)
    }
}
