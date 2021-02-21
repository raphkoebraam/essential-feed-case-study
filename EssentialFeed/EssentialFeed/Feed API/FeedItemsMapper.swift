//
//  Created by Raphael Silva on 23/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

public final class FeedItemsMapper {
    
    private struct Root: Decodable {
        private let items: [Item]

        var images: [FeedImage] {
            items.map {
                FeedImage(
                    id: $0.id,
                    description: $0.description,
                    location: $0.location,
                    url: $0.image
                )
            }
        }

        private struct Item: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }
    }

    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
                throw Error.invalidData
        }
        
        return root.images
    }
}
