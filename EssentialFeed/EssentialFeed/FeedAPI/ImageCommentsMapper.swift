//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 21/02/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import Foundation

internal final class ImageCommentsMapper {

    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    internal static func map(
        data: Data,
        from response: HTTPURLResponse
    ) throws -> [RemoteFeedItem] {
        guard isOK(response),
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }

    private static func isOK(
        _ response: HTTPURLResponse
    ) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
