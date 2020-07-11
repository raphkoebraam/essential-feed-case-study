//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    deinit {
        cleanUpReferencesToPresistentStores()
    }

    public init(url: URL) throws {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        persistentContainer = try NSPersistentContainer.load(modelName: "CoreDataFeedStore", url: url, in: bundle)
        context = persistentContainer.newBackgroundContext()
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPresistentStores() {
        context.performAndWait {
            let coordinator = self.persistentContainer.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
}
