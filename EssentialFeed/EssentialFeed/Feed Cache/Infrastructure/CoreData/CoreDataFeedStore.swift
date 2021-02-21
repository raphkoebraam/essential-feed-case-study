//
//  Created by Raphael Silva on 21/03/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {
    
    private static let modelName = "CoreDataFeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    deinit {
        cleanUpReferencesToPresistentStores()
    }

    public init(url: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            persistentContainer = try NSPersistentContainer.load(name: CoreDataFeedStore.modelName, model: model, url: url)
            context = persistentContainer.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentStores(error)
        }
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
