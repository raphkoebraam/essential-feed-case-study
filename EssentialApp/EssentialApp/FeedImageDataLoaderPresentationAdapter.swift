//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import Foundation

final class FeedImageDataLoaderPresentationAdapter<
    View: FeedImageView,
    Image
>:
    FeedImageCellControllerDelegate
where
    View.Image == Image
{
    private let model: FeedImage

    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher

    private var cancellable: Cancellable?
    
    var presenter: FeedImagePresenter<View, Image>?
    
    init(
        model: FeedImage,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher
    ) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model

        cancellable = imageLoader(model.url)
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break

                case let .failure(error):
                    self?.presenter?.didFinishLoadingImageData(
                        with: error,
                        for: model
                    )
                }
            }, receiveValue: { [weak self] in
                self?.presenter?.didFinishLoadingImageData(
                    with: $0,
                    for: model
                )
            })
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
