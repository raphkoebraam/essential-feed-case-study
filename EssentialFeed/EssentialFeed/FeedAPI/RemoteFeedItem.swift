//
//  Created by Raphael Silva on 25/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
