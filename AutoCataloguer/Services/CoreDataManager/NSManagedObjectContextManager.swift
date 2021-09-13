//
//  NSManagedObjectContextManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 10.09.2021.
//

import Foundation
import CoreData

protocol NSManagedObjectContextProtocol {
    
    func allEntities<T: NSManagedObject>(withType type: T.Type) throws -> [T]
    func allEntities<T: NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T]
    func addEntity<T: NSManagedObject>(withType type: T.Type) -> T?
    func save() throws
    func delete(_ object: NSManagedObject)
    
}

extension NSManagedObjectContext: NSManagedObjectContextProtocol {
    
    func allEntities<T>(withType type: T.Type) throws -> [T] where T : NSManagedObject {
        return try allEntities(withType: type, predicate: nil)
    }
    
    func allEntities<T>(withType type: T.Type, predicate: NSPredicate?) throws -> [T] where T : NSManagedObject {
        
        let request = NSFetchRequest<T>(entityName: T.description())
        request.predicate = predicate
        let results = try self.fetch(request)
        
        return results
    }
    
    func addEntity<T>(withType type: T.Type) -> T? where T : NSManagedObject {
        let entityName = T.description()
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: self) else {
            return nil
        }
        
        let record = T(entity: entity, insertInto: self)
        return record
        
    }
    
}
