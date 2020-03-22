//
//  ManagedFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged internal var id: UUID
    @NSManaged internal var imageDescription: String?
    @NSManaged internal var location: String?
    @NSManaged internal var url: URL
    @NSManaged internal var cache: ManagedCache
}

extension ManagedFeedImage {
    internal var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
    }
    
    internal static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let managedFeed: [ManagedFeedImage] = localFeed.map {
            let managed = ManagedFeedImage(context: context)
            managed.id = $0.id
            managed.imageDescription = $0.description
            managed.location = $0.location
            managed.url = $0.url
            return managed
        }
        
        return NSOrderedSet(array: managedFeed)
    }
}
