//
//  Created by Raphael Silva on 17/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
