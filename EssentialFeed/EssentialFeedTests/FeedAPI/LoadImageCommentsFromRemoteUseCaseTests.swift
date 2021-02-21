//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 21/02/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import EssentialFeed
import XCTest

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }
        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 150, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: failure(.invalidData), when: {
                let jsonData = makeItemsJSONData(with: [])
                client.complete(withStatusCode: code, data: jsonData, at: index)
            })
        }
    }

    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]

        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: failure(.invalidData), when: {
                let invalidJSON = Data("invalid json".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            })
        }
    }

    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]

        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: .success([]), when: {
                let emptyListJSON = makeItemsJSONData(with: [])
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            })
        }
    }

    func test_load_deliversItemsOn2xxHTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = makeItem(id: UUID(),
                             imageURL: URL(string: "http://a-url.com")!)

        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "http://another-url.com")!)

        let items = [item1.model, item2.model]

        let samples = [200, 201, 250, 280, 299]

        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: .success(items), when: {
                let jsonData = makeItemsJSONData(with: [item1.json, item2.json])
                client.complete(withStatusCode: code, data: jsonData, at: index)
            })
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)

        var capturedResults = [RemoteImageCommentsLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSONData(with: []))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    func expect(sut: RemoteImageCommentsLoader, toCompleteWith expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {

        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receveidItems), .success(expectedItems)):
                XCTAssertEqual(receveidItems, expectedItems, file: file, line: line)
            case let (.failure(receveidError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receveidError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }

        return (item, json)
    }

    private func makeItemsJSONData(with items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        trackMemoryLeaks(client, file: file, line: line)
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        trackMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }

    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
}
