//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
    @NSManaged internal var timestamp: Date
    @NSManaged internal var feed: NSOrderedSet
}

extension ManagedCache {
    internal var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
    
    @nonobjc internal class func fetchRequest() -> NSFetchRequest<ManagedCache> {
        return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
    }
    
    internal static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request: NSFetchRequest<ManagedCache> = fetchRequest()
         request.returnsObjectsAsFaults = false
         return try context.fetch(request).first
     }
    
    internal static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
         try find(in: context).map(context.delete)
         return ManagedCache(context: context)
     }
}
