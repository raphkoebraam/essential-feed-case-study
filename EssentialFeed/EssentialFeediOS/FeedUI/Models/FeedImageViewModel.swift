//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 27/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation
import UIKit
import EssentialFeed

final class FeedImageViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    var location: String? {
        return model.location
    }
    
    var description: String? {
        return model.description
    }
    
    var hasLocation: Bool {
        return model.location != nil
    }
    
    var onImageLoad: Observer<UIImage>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStatechange: Observer<Bool>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStatechange?(false)
        task = imageLoader.loadImageData(from: model.url, completion: { [weak self] result in
            self?.handle(result)
        })
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStatechange?(true)
        }
        
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
