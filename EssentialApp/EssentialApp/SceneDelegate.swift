//
//  Created by Raphael Silva on 12/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit
import CoreData
import Combine
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral)
        )
    }()
    private lazy var store: FeedStore & FeedImageDataStore = {
        return try! CoreDataFeedStore(
            url: NSPersistentContainer.defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite")
        )
    }()
    private lazy var localFeedLoader: LocalFeedLoader = {
        return LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(
        httpClient: HTTPClient,
        store: FeedStore & FeedImageDataStore
    ) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }
    
    func sceneWillResignActive(
        _ scene: UIScene
    ) {
        localFeedLoader.validateCache(completion: { _ in })
    }
    
    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposed(
                withFeedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeImageLoaderWithRemoteFallback
            )
        )
        window?.makeKeyAndVisible()
    }

    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
        let remoteURL = URL(
            string: "https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential_app_feed.json"
        )!

        let remoteFeedLoader = RemoteFeedLoader(
            url: remoteURL,
            client: httpClient
        )

        return remoteFeedLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }

    private func makeImageLoaderWithRemoteFallback(
        url: URL
    ) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [remoteImageLoader] in
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url)
            })
    }
}

extension RemoteLoader: FeedLoader where Resource == [FeedImage] {}
