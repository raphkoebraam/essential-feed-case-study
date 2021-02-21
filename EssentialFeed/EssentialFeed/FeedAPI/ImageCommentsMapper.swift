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
        private let items: [Item]

        var comments: [ImageComment] {
            items.map {
                ImageComment(
                    id: $0.id,
                    message: $0.message,
                    createAt: $0.created_at,
                    username: $0.author.username
                )
            }
        }

        private struct Item: Decodable {
            let id: UUID
            let message: String
            let created_at: Date
            let author: Author
        }

        private struct Author: Decodable {
            let username: String
        }
    }

    internal static func map(
        data: Data,
        from response: HTTPURLResponse
    ) throws -> [ImageComment] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard isOK(response),
              let root = try? decoder.decode(
                Root.self,
                from: data)
        else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.comments
    }

    private static func isOK(
        _ response: HTTPURLResponse
    ) -> Bool {
        (200...299).contains(response.statusCode)
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
    }
}
