//
//  File.swift
//  
//
//  Created by Jonathan Ngabo on 2021-04-30.
//

import Foundation
import CoreData

public class ManagedContext {
    public static let shared = ManagedContext()

    lazy var persistentContainer: NSPersistentContainer = {
        
        let momdName = "LeagueMobileChallenge"

        guard let modelURL = Bundle.module.url(forResource: momdName, withExtension:"momd") else {
                fatalError("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        return NSPersistentContainer(name: momdName, managedObjectModel: mom)

        }()

    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
