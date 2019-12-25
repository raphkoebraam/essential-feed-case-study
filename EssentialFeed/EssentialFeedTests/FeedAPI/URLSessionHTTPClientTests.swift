//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 23/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observerRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        
        let receivedError = resultError(forData: nil, response: nil, error: requestError)
        
        XCTAssertEqual(receivedError as NSError?, requestError)
    }
    
    /** Invalid States
     |  Data?   |   URLResponse?    |   Error?  |
     --------------------------------------------
     |  nil     |  nil              |   nil     |
     --------------------------------------------
     |  nil     |  URLResponse      |   nil     |
     --------------------------------------------
     |  nil     |  HTTPURLResponse  |   nil     | // moved to its own test `test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponse`
     --------------------------------------------
     |  value   |  nil              |   nil     |
     --------------------------------------------
     |  value   |  nil              |   value   |
     --------------------------------------------
     |  nil     |  URLResponse      |   value   |
     --------------------------------------------
     |  nil     |  HTTPURLResponse  |   value   |
     --------------------------------------------
     |  value   |  URLResponse      |   value   |
     --------------------------------------------
     |  value   |  HTTPURLResponse  |   value   |
     --------------------------------------------
     |  value   |  URLResponse      |   nil     |
     --------------------------------------------
     */
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultError(forData: nil, response: nil, error: nil))
        XCTAssertNotNil(resultError(forData: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultError(forData: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultError(forData: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultError(forData: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(forData: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(forData: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(forData: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(forData: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValues(forData: data, response: response, error: nil)
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValues(forData: nil, response: response, error: nil)
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackMemoryLeaks(for: sut, file: file, line: line)
        return sut
    }
    
    private func resultValues(forData data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        URLProtocolStub.stub(data: data, response: response, error: error)

        let result = self.result(forData: data, response: response, error: error, file: file, line: line)
        
        switch result {
        case let .success(data, response):
            return (data, response)
        default:
            XCTFail("Expected success but got \(result) instead.", file: file, line: line)
            return nil
        }
    }
    
    private func resultError(forData data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let result = self.result(forData: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure but got \(result) instead.", file: file, line: line)
            return nil
        }
    }
    
    private func result(forData data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClientResult {
        URLProtocolStub.stub(data: data, response: response, error: error)

        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClientResult!
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private class URLProtocolStub: URLProtocol {
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
            let requestObserver: ((URLRequest) -> Void)?
        }
        
        private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
        private static var _stub: Stub?
        private static var stub: Stub? {
            get { return queue.sync { _stub } }
            set { queue.sync { _stub = newValue }}
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error, requestObserver: nil)
        }
        
        static func observerRequests(observer: @escaping (URLRequest) -> Void) {
            stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocolStub.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        
        // MARK: URLProtocol
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let stub = URLProtocolStub.stub else { return }
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }
            
            stub.requestObserver?(request)
        }
        
        override func stopLoading() {}
    }
}