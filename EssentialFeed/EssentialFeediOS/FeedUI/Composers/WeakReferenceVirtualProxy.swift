//
//  WeakReferenceVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit

final class WeakReferenceVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakReferenceVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakReferenceVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        object?.display(viewModel)
    }
}
