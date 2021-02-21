//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 21/02/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import Foundation

public final class FeedImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(
        data: Data,
        from response: HTTPURLResponse
    ) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
