//
//  CoreDataManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation
import CoreData

protocol CoreDataInputProtocol: AnyObject {

    var persistentContainer: NSPersistentContainer { get set}
    func saveContext()
    
}

class CoreDataManager: CoreDataInputProtocol {
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CatalogueModel")
        container.loadPersistentStores(completionHandler: {  (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
}
