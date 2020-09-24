//
//  Created by Raphael Silva on 18/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class FeedSnapshotTests: XCTestCase {
    
    func test_emptyFeed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_FEED-light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_FEED-dark")
    }
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT-light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_CONTENT-dark")
    }
    
    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_ERROR_MESSAGE-light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE-dark")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()
        
        sut.display(feedWithFailedImageLoading())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING-light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING-dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> FeedTableViewController {
        let bundle = Bundle(for: FeedTableViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedTableViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyFeed() -> [FeedImageCellController] {
        return []
    }
    
    private func feedWithContent() -> [ImageStub] {
        return [
            ImageStub(description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                      location: "East Side Gallery\nMemorial in Berlin, Germany",
                      image: UIImage.from(.red)),
            ImageStub(description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                      location: "Garth Pier",
                      image: UIImage.from(.green))
        ]
    }
    
    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [
            ImageStub(description: nil,
                      location: "Cannon Street, London",
                      image: nil),
            ImageStub(description: nil,
                      location: "Brighton Seafront",
                      image: nil)
        ]
    }
    
    private func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)
            
            try? snapshotData?.write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
    
    private func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            
            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        
        return data
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection
    
    static func iPhone8(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        return SnapshotConfiguration(size: CGSize(width: 375, height: 667),
                                     safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                                     layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                                     traitCollection: UITraitCollection(traitsFrom: [
                                        .init(forceTouchCapability: .available),
                                        .init(layoutDirection: .leftToRight),
                                        .init(preferredContentSizeCategory: .medium),
                                        .init(userInterfaceIdiom: .phone),
                                        .init(horizontalSizeClass: .compact),
                                        .init(verticalSizeClass: .regular),
                                        .init(displayScale: 2),
                                        .init(displayGamut: .P3),
                                        .init(userInterfaceStyle: style)
                                     ]))
    }
}

private final class SnapshotWindow: UIWindow {
    
    private var configuration: SnapshotConfiguration = .iPhone8(style: .light)
    
    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }
    
    override var traitCollection: UITraitCollection {
        return configuration.traitCollection
    }
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

private extension FeedTableViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }
        
        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    
    weak var controller: FeedImageCellController?
    let viewModel: FeedImageViewModel<UIImage>
    
    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(description: description,
                                       location: location,
                                       image: image,
                                       isLoading: false,
                                       shouldRetry: image == nil)
    }
    
    func didRequestImage() {
        controller?.display(viewModel)
    }
    
    func didCancelImageRequest() {}
}
