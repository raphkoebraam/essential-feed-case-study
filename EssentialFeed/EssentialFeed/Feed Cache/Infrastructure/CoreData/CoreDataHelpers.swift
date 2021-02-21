//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation
import CoreData

// MARK: - NSPersistentContainer Extension

extension NSPersistentContainer {
    
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let persistentStoreDescription = NSPersistentStoreDescription(url: url)
        let persistentContainer = NSPersistentContainer(name: name, managedObjectModel: model)
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        
        var loadError: Swift.Error?
        persistentContainer.loadPersistentStores { loadError = $1}
        try loadError.map { throw $0 }
        
        return persistentContainer
    }
}

// MARK: - NSManagedObjectModel

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd").flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
