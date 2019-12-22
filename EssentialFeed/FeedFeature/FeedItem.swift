//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 21/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import Foundation

struct FeedItem {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}