//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 27/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposed(withFeedLoader feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedTableViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        
        let feedController = makeFeedTableViewController(delegate: presentationAdapter,
                                                         title: FeedPresenter.title)
        
        feedController.delegate = presentationAdapter
        presentationAdapter.presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedController,
                                                                                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
                                                      loadingView: WeakReferenceVirtualProxy(feedController),
                                                      errorView: WeakReferenceVirtualProxy(feedController))
        
        return feedController
    }

    static func makeFeedTableViewController(delegate: FeedTableViewControllerDelegate, title: String) -> FeedTableViewController {
        let bundle = Bundle(for: FeedTableViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedTableViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}
