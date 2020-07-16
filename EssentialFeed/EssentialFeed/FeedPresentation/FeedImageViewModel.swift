//
//  Created by Raphael Silva on 27/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

public struct FeedImageViewModel<Image> {
    
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        return location != nil
    }
}
