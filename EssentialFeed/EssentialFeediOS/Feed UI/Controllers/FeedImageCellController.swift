//
//  Created by Raphael Silva on 27/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit
import EssentialFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: NSObject {
    public typealias ResourceViewModel = UIImage

    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageTableViewCell?
    
    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
}

extension FeedImageCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.onRetry = { [weak self] in
            self?.delegate.didRequestImage()
        }
        delegate.didRequestImage()
        return cell!
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate.didRequestImage()
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }

    private func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
}

extension FeedImageCellController:  ResourceView, ResourceLoadingView, ResourceErrorView {
    
    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
