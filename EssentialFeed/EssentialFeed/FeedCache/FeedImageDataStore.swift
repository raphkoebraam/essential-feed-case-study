//
//  Created by Raphael Silva on 09/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(for url: URL, completion: @escaping (RetrievalResult) -> Void)
}
