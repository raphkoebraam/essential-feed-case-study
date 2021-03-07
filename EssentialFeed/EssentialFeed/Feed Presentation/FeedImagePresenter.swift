//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

public protocol FeedImageView {
    associatedtype Image
    
    func display(_ viewModel: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private struct InvalidImageDataError: Error {}
    
    private let view: View
    private let imageTransformer: (Data) -> Image?

    public static func map(_ image: FeedImage) -> FeedImageViewModel<Image> {
        FeedImageViewModel(
            description: image.description,
            location: image.location,
            image: nil,
            isLoading: false,
            shouldRetry: false)
    }
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description,
                                        location: model.location,
                                        image: nil,
                                        isLoading: true,
                                        shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        view.display(FeedImageViewModel(description: model.description,
                                        location: model.location,
                                        image: image,
                                        isLoading: false,
                                        shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description,
                                        location: model.location,
                                        image: nil,
                                        isLoading: false,
                                        shouldRetry: true))
    }
}
