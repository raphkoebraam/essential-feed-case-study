//
//  Created by Raphael Silva on 17/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
