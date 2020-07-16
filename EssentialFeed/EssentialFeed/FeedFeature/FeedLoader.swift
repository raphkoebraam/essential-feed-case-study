//
//  Created by Raphael Silva on 21/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
