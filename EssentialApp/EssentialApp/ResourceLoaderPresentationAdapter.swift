//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class ResourceLoaderPresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>

    private var cancellable: Cancellable?

    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(
        loader: @escaping () -> AnyPublisher<Resource, Error>
    ) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()

        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break

                case let .failure(error):
                    self?.presenter?.didFinishLoading(
                        with: error
                    )
                }
            }, receiveValue: { [weak self] in
                self?.presenter?.didFinishLoading(
                    with: $0
                )
            })
    }
}

extension ResourceLoaderPresentationAdapter: FeedTableViewControllerDelegate {
    func didRequestFeedRefresh() {
        loadResource()
    }
}
