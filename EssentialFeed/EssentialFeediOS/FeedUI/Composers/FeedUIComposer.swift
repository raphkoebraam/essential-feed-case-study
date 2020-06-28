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
        
        let feedController = FeedTableViewController.makeWith(delegate: presentationAdapter,
                                                              title: FeedPresenter.title)
        
        feedController.delegate = presentationAdapter
        presentationAdapter.presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedController,
                                                                                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
                                                      loadingView: WeakReferenceVirtualProxy(feedController))
        
        return feedController
    }
}

private extension FeedTableViewController {
    static func makeWith(delegate: FeedTableViewControllerDelegate, title: String) -> FeedTableViewController {
        let bundle = Bundle(for: FeedTableViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedTableViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}

private final class FeedViewAdapter: FeedView {
    
    private weak var controller: FeedTableViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedTableViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakReferenceVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(view: WeakReferenceVirtualProxy(view),
                                                   imageTransformer: UIImage.init)
            
            return view
        }
    }
}
