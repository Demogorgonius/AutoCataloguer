//
//  DataManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 25.09.2021.
//

import Foundation
import CoreData

protocol DataManagerProtocol: AnyObject {
    
    func getAllCatalogue(completionBlock: @escaping (Result<[Catalogues]?, Error>) -> Void)
    func getAllElements(completionBlock: @escaping (Result<[Element], Error>) -> Void)
    func getCatalogue(catalogueName: String, completionBlock: @escaping (Result<Catalogues, Error>) -> Void)
    func getElementsFromCatalogue(catalogue: Catalogues, completionBlock: @escaping (Result<Element, Error>) -> Void)
    func saveCatalogue(catalogueName: String, catalogueType: String, cataloguePlace: String, catalogueIsFull: Bool, completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func saveElement(element: Element, catalogue: Catalogues, completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func deleteCatalogue(catalogue: Catalogues, completionBlock: @escaping(Result<Bool, Error>) -> Void)
//    var catalogue: Catalogues {get set}
//    var element: Element {get set}

}

final class DataManagerClass: DataManagerProtocol {
  
    
   // var description: String
    
    
//    var catalogue: Catalogues
//    var element: Element
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
//        self.catalogue = catalogue
//        self.element = element
        self.context = context
    }
 
    
    
   func getAllCatalogue(completionBlock: @escaping (Result<[Catalogues]?, Error>) -> Void) {
    
       let request = NSFetchRequest<Catalogues>(entityName: "Catalogues")
       request.sortDescriptors = [NSSortDescriptor(keyPath: \Catalogues.nameCatalogue, ascending: true)]
       
       do {
           let catalogues = try context.fetch(request)
           completionBlock(.success(catalogues))
       } catch {
           completionBlock(.failure(error))
       }
       
       
   }
    
    func getAllElements(completionBlock: @escaping (Result<[Element], Error>) -> Void) {
     
        let request = NSFetchRequest<Element>(entityName: "Element")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Element.title, ascending: true)]
        
        do {
            let elements = try context.fetch(request)
            completionBlock(.success(elements))
        } catch {
            completionBlock(.failure(error))
        }
        
    }
    
    func getCatalogue(catalogueName: String, completionBlock: @escaping (Result<Catalogues, Error>) -> Void) {
        
    }
    
    func getElementsFromCatalogue(catalogue: Catalogues, completionBlock: @escaping (Result<Element, Error>) -> Void) {
        
    }
    
    func saveCatalogue(catalogueName: String, catalogueType: String, cataloguePlace: String, catalogueIsFull: Bool, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
  
        let catalogueForSave = NSEntityDescription.insertNewObject(forEntityName: "Catalogues", into: context) as! Catalogues
        catalogueForSave.nameCatalogue = catalogueName
        catalogueForSave.typeOfCatalogue = catalogueType
        catalogueForSave.placeOfCatalogue = cataloguePlace
        catalogueForSave.isFull = catalogueIsFull
        
        if context.hasChanges {
            do {
                try context.save()
                completionBlock(.success(true))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
    
    func saveElement(element: Element, catalogue: Catalogues, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func deleteCatalogue(catalogue: Catalogues, completionBlock: @escaping(Result<Bool, Error>) -> Void) {
        context.delete(catalogue)
        do {
            try context.save()
            completionBlock(.success(true))
        } catch {
            completionBlock(.failure(error))
        }
    }

}

