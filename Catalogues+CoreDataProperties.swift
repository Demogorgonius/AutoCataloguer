//
//  Catalogues+CoreDataProperties.swift
//  
//
//  Created by Sergey on 25.01.2022.
//
//

import Foundation
import CoreData


extension Catalogues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catalogues> {
        return NSFetchRequest<Catalogues>(entityName: "Catalogues")
    }

    @NSManaged public var dateOfDeleteCatalogue: Date?
    @NSManaged public var isDeletedCatalogue: Bool
    @NSManaged public var isFull: Bool
    @NSManaged public var nameCatalogue: String?
    @NSManaged public var placeOfCatalogue: String?
    @NSManaged public var typeOfCatalogue: String?
    @NSManaged public var element: NSSet?

}

// MARK: Generated accessors for element
//extension Catalogues {
//
//    @objc(addElementObject:)
//    @NSManaged public func addToElement(_ value: Element)
//
//    @objc(removeElementObject:)
//    @NSManaged public func removeFromElement(_ value: Element)
//
//    @objc(addElement:)
//    @NSManaged public func addToElement(_ values: NSSet)
//
//    @objc(removeElement:)
//    @NSManaged public func removeFromElement(_ values: NSSet)
//
//}
