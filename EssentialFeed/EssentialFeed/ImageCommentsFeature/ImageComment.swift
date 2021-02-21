//
//  ImageComment.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 21/02/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import Foundation

public struct ImageComment: Equatable {
    public let id: UUID
    public let message: String
    public let createAt: Date
    public let username: String

    public init(
        id: UUID,
        message: String,
        createAt: Date,
        username: String
    ) {
        self.id = id
        self.message = message
        self.createAt = createAt
        self.username = username
    }
}
