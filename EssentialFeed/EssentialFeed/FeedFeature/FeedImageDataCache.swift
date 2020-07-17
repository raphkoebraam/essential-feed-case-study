//
//  Created by Raphael Silva on 17/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
   typealias Result = Swift.Result<Void, Error>

   func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
