//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ManagedCache> {
        return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
    }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request: NSFetchRequest<ManagedCache> = fetchRequest()
         request.returnsObjectsAsFaults = false
         return try context.fetch(request).first
     }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
         try find(in: context).map(context.delete)
         return ManagedCache(context: context)
     }
}
