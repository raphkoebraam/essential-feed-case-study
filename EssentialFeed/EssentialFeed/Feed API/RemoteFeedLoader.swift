//
//  Created by Raphael Silva on 22/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

extension RemoteFeedLoader {
    public convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
