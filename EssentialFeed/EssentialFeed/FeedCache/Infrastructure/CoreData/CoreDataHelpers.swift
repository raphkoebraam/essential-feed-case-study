//
//  CoreDataHelpers.swift
//  FeedStoreChallenge
//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

// MARK: - NSPersistentContainer Extension

internal extension NSPersistentContainer {
    enum LoadError: Swift.Error {
        case didNotFindModel
        case didFailToLoadPersistentStores(Swift.Error)
    }
    
    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadError.didNotFindModel
        }
        
        var loadError: Swift.Error?
        
        let persistentStoreDescription = NSPersistentStoreDescription(url: url)
        let persistentContainer = NSPersistentContainer(name: name, managedObjectModel: model)
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores { (_, error) in
            loadError = error
        }
        
        try loadError.map { throw LoadError.didFailToLoadPersistentStores($0) }
        
        return persistentContainer
    }
}

// MARK: - NSManagedObjectModel

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd").flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
