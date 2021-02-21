//
//  Created by Raphael Silva on 11/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            })
        }
    }
    
    public func retrieve(for url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                return try ManagedFeedImage.first(with: url, in: context)?.data
            })
        }
    }
}
