//
//  DataManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 25.09.2021.
//

import Foundation
import CoreData
import UIKit

protocol DataManagerProtocol: AnyObject {
    
    func getAllCatalogue(completionBlock: @escaping (Result<[Catalogues]?, Error>) -> Void)
    func getAllElements(display: DisplayType, completionBlock: @escaping (Result<[Element], Error>) -> Void)
    func getCatalogue(catalogueName: String, completionBlock: @escaping (Result<Catalogues, Error>) -> Void)
    func getElementsFromCatalogue(catalogue: Catalogues, display: DisplayType, completionBlock: @escaping (Result<[Element], Error>) -> Void)
    func saveCatalogue(catalogueName: String, catalogueType: String, cataloguePlace: String, catalogueIsFull: Bool, completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func saveElement(elementType: String, elementAuthor: String, elementRealiseDate: String, elementTitle: String, elementDescription: String, elementParentCatalogue: String, catalogue: Catalogues, elementCoverPhoto: UIImage?, elementFirstPagePhoto: UIImage?, completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func deleteCatalogue(catalogue: Catalogues, completionBlock: @escaping(Result<Bool, Error>) -> Void)
    func editCatalogue(catalogue: Catalogues, completionBlock: @escaping(Result<Bool, Error>) -> Void)
    func markElementAsDeleted(element: Element, completionBlock: @escaping (Result<Bool,Error>) -> Void)
    func deleteElement(element: Element?, completionBlock: @escaping(Result<Bool, Error>) -> Void)
    func editElement(element: Element, parentCatalogue: String, description: String, completionBlock: @escaping (Result<Element, Error>) -> Void)
    //    var catalogue: Catalogues {get set}
    //    var element: Element {get set}
    
}

final class DataManagerClass: DataManagerProtocol {
    
    
    // var description: String
    
    
    //    var catalogue: Catalogues
    //    var element: Element
    var context: NSManagedObjectContext
    let formatter = DateFormatter()
    
    init(context: NSManagedObjectContext) {
        //        self.catalogue = catalogue
        //        self.element = element
        self.context = context
    }
    
    //MARK: - Get All Catalogue
    func getAllCatalogue(completionBlock: @escaping (Result<[Catalogues]?, Error>) -> Void) {
        
        let request = NSFetchRequest<Catalogues>(entityName: "Catalogues")
        request.predicate = NSPredicate(format: "%K != NIL", #keyPath(Catalogues.typeOfCatalogue))
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Catalogues.nameCatalogue, ascending: true)]
        
        do {
            let catalogues = try context.fetch(request)
            completionBlock(.success(catalogues))
        } catch {
            completionBlock(.failure(error))
        }
        
        
    }
    
    //MARK: - Get All Elements
    
    func getAllElements(display: DisplayType, completionBlock: @escaping (Result<[Element], Error>) -> Void) {
        
        let request = NSFetchRequest<Element>(entityName: "Element")
        
        switch display {
        case .deleted:
            request.predicate = NSPredicate(format: "%K == TRUE", #keyPath(Element.isDeletedElement))
        case .existing:
            request.predicate = NSPredicate(format: "%K != TRUE AND parentCatalogue != NIL", #keyPath(Element.isDeletedElement))
        case .noCatalogue:
            request.predicate = NSPredicate(format: "%K == NIL", #keyPath(Element.parentCatalogue))
        case .allElement:
            request.predicate = NSPredicate(format: "%K != NIL", #keyPath(Element.type))
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Element.title, ascending: true)]
        
        do {
            let elements = try context.fetch(request)
            completionBlock(.success(elements))
        } catch {
            completionBlock(.failure(error))
        }
        
    }
    
    //MARK: - Mark deleted element
    
    func markElementAsDeleted(element: Element, completionBlock: @escaping (Result<Bool,Error>) -> Void) {
        element.isDeletedElement = true
        if context.object(with: element.objectID).isUpdated {
            do {
                try context.save()
                completionBlock(.success(true))
            } catch {
                completionBlock(.failure(error))
            }
        }
        
    }
    
    
    //MARK: - Get Catalogue
    
    func getCatalogue(catalogueName: String, completionBlock: @escaping (Result<Catalogues, Error>) -> Void) {
        
        let request = NSFetchRequest<Catalogues>(entityName: "Catalogues")
        request.predicate = NSPredicate(format: "%K == %@ AND isDeletedCatalogue != TRUE", #keyPath(Catalogues.nameCatalogue), catalogueName)
        
        do {
            let catalogues = try context.fetch(request)
            if catalogues.count == 0 {
                completionBlock(.failure(ValidateInputError.findNil))
            } else {
                completionBlock(.success(catalogues[0]))
            }
        } catch {
            completionBlock(.failure(error))
        }
        
    }
    
    //MARK: - Get Element from catalogue
    
    func getElementsFromCatalogue(catalogue: Catalogues, display: DisplayType, completionBlock: @escaping (Result<[Element], Error>) -> Void) {
        
        let fetchElements = NSFetchRequest<Element>(entityName: "Element")
        
        switch display {
        case .deleted:
            fetchElements.predicate = NSPredicate(format: "isDeletedElement == TRUE AND %K == %@", #keyPath(Element.parentCatalogue), catalogue.nameCatalogue! )
        case .existing:
            fetchElements.predicate = NSPredicate(format: "isDeletedElement == FALSE AND %K == %@", #keyPath(Element.parentCatalogue), catalogue.nameCatalogue! )
        case .noCatalogue:
            fetchElements.predicate = NSPredicate(format: "parentCatalogue == NIL AND %K == %@", #keyPath(Element.parentCatalogue), catalogue.nameCatalogue! )
        case .allElement:
            fetchElements.predicate = NSPredicate(format: "type != NIL AND %K == %@", #keyPath(Element.parentCatalogue), catalogue.nameCatalogue! )
        }
        
        //fetchElements.predicate = NSPredicate(format: "%K == %@", #keyPath(Element.parentCatalogue), catalogue.nameCatalogue!)
        
        do {
            let elements = try context.fetch(fetchElements)
            completionBlock(.success(elements))
        } catch {
            completionBlock(.failure(error))
        }
        
    }
    
    //MARK: - Save Catalogue
    
    func saveCatalogue(catalogueName: String, catalogueType: String, cataloguePlace: String, catalogueIsFull: Bool, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        let catalogueForSave = NSEntityDescription.insertNewObject(forEntityName: "Catalogues", into: context) as! Catalogues
        catalogueForSave.nameCatalogue = catalogueName
        catalogueForSave.typeOfCatalogue = catalogueType
        catalogueForSave.placeOfCatalogue = cataloguePlace
        catalogueForSave.isFull = catalogueIsFull
        catalogueForSave.isDeletedCatalogue = false
        
        if context.hasChanges {
            do {
                try context.save()
                completionBlock(.success(true))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
    
    //MARK: - Save Element
    
    func saveElement(elementType: String, elementAuthor: String, elementRealiseDate: String, elementTitle: String, elementDescription: String, elementParentCatalogue: String, catalogue: Catalogues, elementCoverPhoto: UIImage?, elementFirstPagePhoto: UIImage?, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        let elementForSave = NSEntityDescription.insertNewObject(forEntityName: "Element", into: context) as! Element
        elementForSave.catalogue = catalogue
        elementForSave.elementDescription = elementDescription
        elementForSave.releaseDate = elementRealiseDate
        elementForSave.author = elementAuthor
        elementForSave.type = elementType
        elementForSave.title = elementTitle
        elementForSave.parentCatalogue = elementParentCatalogue
        elementForSave.isDeletedElement = false
        if let image = elementCoverPhoto {
            elementForSave.coverImage = image.pngData()
        }
        if let image = elementFirstPagePhoto {
            elementForSave.pageImage = image.pngData()
        }
        
        
        if context.hasChanges {
            do {
                try context.save()
                completionBlock(.success(true))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
    
    //MARK: - Delete Catalogue
    
    func deleteCatalogue(catalogue: Catalogues, completionBlock: @escaping(Result<Bool, Error>) -> Void) {
        
        var elementsFromCatalogue: [Element] = []
        
        getElementsFromCatalogue(catalogue: catalogue, display: .existing) { result in
            switch result {
            case .success(let elements):
                elementsFromCatalogue = elements
            case .failure(_):
                return
            }
        }
        
        for element in elementsFromCatalogue {
            element.catalogue = nil
            element.parentCatalogue = nil
            if context.object(with: element.objectID).isUpdated {
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
            
        }
        
        context.delete(catalogue)
        do {
            try context.save()
            completionBlock(.success(true))
        } catch {
            completionBlock(.failure(error))
        }
    }
    
    
    //MARK: - Edit Catalogue
    
    func editCatalogue(catalogue: Catalogues, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        //       if  context.hasChanges{
        if  context.object(with: catalogue.objectID).isUpdated {
            do {
                try context.save()
                completionBlock(.success(true))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
    
    func deleteElement(element: Element?, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let deleteElement = element else { return }
        if deleteElement.isDeletedElement == false {
            deleteElement.isDeletedElement = true
            formatter.dateFormat = "dd MM yyyy"
            let deleteDate = formatter.string(from: Date())
            deleteElement.elementDescription! += String("\n Date of delete is: \(deleteDate)")
            if context.object(with: deleteElement.objectID).isUpdated {
                do {
                    try context.save()
                    completionBlock(.success(true))
                } catch {
                    completionBlock(.failure(error))
                }
            }
        } else {
            
            context.delete(deleteElement)
            do {
                try context.save()
                completionBlock(.success(true))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
    
    //MARK: - Edit Element
    
    func editElement(element: Element, parentCatalogue: String, description: String, completionBlock: @escaping (Result<Element, Error>) -> Void) {
        
        var newElement: Element!
        let savedElementID = element.objectID.description.components(separatedBy: "<").last?.components(separatedBy: ">").first
        getAllElements(display: .allElement) { result in
            switch result {
            case .success(let elements):
                for elementFind in elements {
                    let oldElementID = elementFind.objectID.description.components(separatedBy: "<").last?.components(separatedBy: ">").first
                    if oldElementID == savedElementID {
                        newElement = elementFind
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        if element.parentCatalogue == parentCatalogue {
            
            
            newElement.elementDescription = description
            
        } else {
            var oldCatalogue: Catalogues!
            getCatalogue(catalogueName: element.parentCatalogue!) { result in
                
                switch result {
                case .success(let catalogue):
                    oldCatalogue = catalogue
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
            newElement.parentCatalogue = parentCatalogue
            newElement.elementDescription = description
            var newCatalogue: Catalogues!
            getCatalogue(catalogueName: parentCatalogue) { result in
                
                switch result {
                case .success(let catalogue):
                    newCatalogue = catalogue
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
            newElement.catalogue = newCatalogue
            oldCatalogue.removeFromElement(element)
        }
        
        if context.object(with: element.objectID).isUpdated {
            do {
                try context.save()
                completionBlock(.success(element))
            } catch {
                completionBlock(.failure(error))
            }
        }
        
    }
    
}

