//
//  Created by Raphael Silva on 23/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClientTests: XCTestCase {
    
    override func tearDown() {
        URLProtocolStub.removeStub()
        
        super.tearDown()
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
        
        let receivedError = resultError(for: (data: nil, response: nil, error: requestError))
        
        XCTAssertNotNil(receivedError)
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
        XCTAssertNotNil(resultError(for: (data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultError(for: (data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultError(for: (data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultError(for: (data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultError(for: (data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(for: (data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(for: (data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(for: (data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(for: (data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValues(for: (data: data, response: response, error: nil))
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValues(for: (data: nil, response: response, error: nil))
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_cancelGetFromURLTask_cancelsURLRequest() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        let task = makeSUT().get(from: url) { (result) in
            switch result {
            case let .failure(error as NSError) where error.code == URLError.cancelled.rawValue:
                break
            default:
                XCTFail("Expected cancelled result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        task.cancel()
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        trackMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultValues(for values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = self.result(for: values, file: file, line: line)
        
        switch result {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success but got \(result) instead.", file: file, line: line)
            return nil
        }
    }
    
    private func resultError(for values: (data: Data?, response: URLResponse?, error: Error?), taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = self.result(for: values, taskHandler: taskHandler, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure but got \(result) instead.", file: file, line: line)
            return nil
        }
    }
    
    private func result(for values: (data: Data?, response: URLResponse?, error: Error?)?, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> HTTPClient.Result {
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }

        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.Result!
        taskHandler(sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
