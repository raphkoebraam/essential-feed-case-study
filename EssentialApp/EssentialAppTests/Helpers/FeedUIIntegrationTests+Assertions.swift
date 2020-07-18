//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

func assert(_ sut: FeedTableViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
    let view = sut.feedImageView(at: index)
    
    guard let cell = view as? FeedImageTableViewCell else {
        return XCTFail("Expected \(FeedImageTableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
    }
    
    let shouldLocationBeVisible = (image.location != nil)
    XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index \(index)", file: file, line: line)
    XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index \(index)", file: file, line: line)
    XCTAssertEqual(cell.descriptionText, image.description, "Expected location text to be \(String(describing: image.description)) for image view at index \(index)", file: file, line: line)
}

func assert(_ sut: FeedTableViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
    sut.tableView.layoutIfNeeded()
    RunLoop.main.run(until: Date())
    
    let numberOfRenderedFeedImageViews = sut.numberOfRenderedFeedImageViews()
    let feedCount = feed.count
    guard numberOfRenderedFeedImageViews == feedCount else {
        return XCTFail("Expected \(feedCount) images, got \(numberOfRenderedFeedImageViews) instead.")
    }
    
    feed.enumerated().forEach { (index, image) in
        assert(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
    }
}
