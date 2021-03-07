//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    
    private weak var controller: FeedTableViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(
        controller: FeedTableViewController,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher
    ) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = ResourceLoaderPresentationAdapter<Data, WeakReferenceVirtualProxy<FeedImageCellController>>(loader: { [imageLoader] in
                imageLoader(model.url)
            })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter<FeedImageCellController, UIImage>.map(model),
                delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakReferenceVirtualProxy(view),
                loadingView: WeakReferenceVirtualProxy(view),
                errorView: WeakReferenceVirtualProxy(view),
                mapper: {
                    guard let image = UIImage(data: $0) else {
                        throw InvalidImageData()
                    }
                    return image
                })
            
            return view
        })
    }
}

private struct InvalidImageData: Error {}
