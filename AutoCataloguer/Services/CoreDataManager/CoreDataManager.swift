//
//  CoreDataManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation
import CoreData


class CoreDataManager {
    
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        //let container = NSPersistentContainer(name: "CatalogueModel")
        let container = NSPersistentCloudKitContainer(name: "CatalogueModel_18_01_22")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
#if DEBUG
        do {
            // Use the container to initialize the development schema.
            try container.initializeCloudKitSchema(options: [])
        } catch {
            // Handle any errors.
        }
#endif
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                
            }
        }
    }
    
    
    //    var persistentContainer: NSPersistentContainer = {
    //        lazy var context: NSManagedObjectContext = {
    //            persistentContainer.viewContext
    //        }()
    //
    //        let container = NSPersistentContainer(name: "CatalogueModel")
    //        container.loadPersistentStores(completionHandler: {  (storeDescription, error) in
    //            if let error = error as NSError? {
    //                fatalError("Unresolved error \(error), \(error.userInfo)")
    //            }
    //        })
    //
    //        return container
    //    }()
    //
    //    func saveContext() {
    //
    //        let context = persistentContainer.viewContext
    //        if context.hasChanges {
    //            do {
    //                try context.save()
    //            } catch {
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //
    //    }
    
}
