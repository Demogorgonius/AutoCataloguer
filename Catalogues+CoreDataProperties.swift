//
//  Catalogues+CoreDataProperties.swift
//  
//
//  Created by Sergey on 24.01.2022.
//
//

import Foundation
import CoreData


extension Catalogues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catalogues> {
        return NSFetchRequest<Catalogues>(entityName: "Catalogues")
    }

    @NSManaged public var isFull: Bool
    @NSManaged public var nameCatalogue: String?
    @NSManaged public var placeOfCatalogue: String?
    @NSManaged public var typeOfCatalogue: String?
    @NSManaged public var isDeletedCatalogue: Bool
    @NSManaged public var dateOfDelete: Date?
    @NSManaged public var element: Element?

}
