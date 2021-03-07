//
//  Created by Raphael Silva on 27/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Combine
import UIKit
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private typealias FeedPresentationAdapter = ResourceLoaderPresentationAdapter<[FeedImage], FeedViewAdapter>
    
    private init() {}
    
    public static func feedComposed(
        withFeedLoader feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(
            loader: feedLoader
        )
        
        let feedController = makeFeedTableViewController(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )
        
        feedController.delegate = presentationAdapter
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader
            ),
            loadingView: WeakReferenceVirtualProxy(feedController),
            errorView: WeakReferenceVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        
        return feedController
    }

    static func makeFeedTableViewController(
        delegate: FeedTableViewControllerDelegate,
        title: String
    ) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}
