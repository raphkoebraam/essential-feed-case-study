//
//  FeedTableViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Raphael Silva on 24/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import UIKit
import EssentialFeed
import EssentialFeediOS

class FeedTableViewControllerTests: XCTestCase {

    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected a second loading request once user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third loading request once user initiates another load")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
    
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
    
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadFeedCompletion_renderSuccessfullyLoadedFeed() {
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "another location")
        let image2 = makeImage(description: "another description", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assert(sut, isRendering: [])
        
        let feed0 = [image0]
        loader.completeFeedLoading(with: feed0, at: 0)
        assert(sut, isRendering: feed0)
        
        sut.simulateUserInitiatedFeedReload()
        let feed1 = [image0, image1, image2, image3]
        loader.completeFeedLoading(with: feed1, at: 1)
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 4)
        assert(sut, isRendering: feed1)
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        let feed = [image0]
        loader.completeFeedLoading(with: feed, at: 0)
        assert(sut, isRendering: feed)
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assert(sut, isRendering: feed)
    }
    
    func test_feedImageView_loadsImageURLWhenVisible() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let feed = [image0, image1]
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: feed)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first imageURL request once first view becomes visible")
        
        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected second imageURL request once second view becomes visible")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedTableViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedTableViewController(feedLoader: loader, imageLoader: loader)
        trackMemoryLeaks(loader, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
    
    private func assert(_ sut: FeedTableViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageTableViewCell else {
            return XCTFail("Expected \(FeedImageTableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index \(index)", file: file, line: line)
        XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index \(index)", file: file, line: line)
        XCTAssertEqual(cell.descriptionText, image.description, "Expected location text to be \(String(describing: image.description)) for image view at index \(index)", file: file, line: line)
    }
    
    private func assert(_ sut: FeedTableViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        let numberOfRenderedFeedImageViews = sut.numberOfRenderedFeedImageViews()
        let feedCount = feed.count
        guard numberOfRenderedFeedImageViews == feedCount else {
            return XCTFail("Expected \(feedCount) images, got \(numberOfRenderedFeedImageViews) instead.")
        }
        
        feed.enumerated().forEach { (index, image) in
            assert(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        // MARK: - FeedLoader
        
        private(set) var feedRequests = [(FeedLoader.Result) -> Void]()
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            feedRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        
        private(set) var loadedImageURLs = [URL]()
        
        func loadImageData(from url: URL) {
            loadedImageURLs.append(url)
        }
    }
}

private extension FeedTableViewController {
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    private var feedImagesSection: Int {
        return 0
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let indexPath = IndexPath(row: row, section: feedImagesSection)
        return dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func simulateFeedImageViewVisible(at index: Int) {
        _ = feedImageView(at: index)
    }
}

private extension FeedImageTableViewCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
