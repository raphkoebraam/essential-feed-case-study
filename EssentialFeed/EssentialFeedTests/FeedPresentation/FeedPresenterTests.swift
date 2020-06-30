//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 30/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest

final class FeedPresenter {
    
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
