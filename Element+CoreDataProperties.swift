//
//  Element+CoreDataProperties.swift
//  
//
//  Created by Sergey on 25.01.2022.
//
//

import Foundation
import CoreData


extension Element {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Element> {
        return NSFetchRequest<Element>(entityName: "Element")
    }

    @NSManaged public var author: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var dateOfDeleteElement: Date?
    @NSManaged public var elementDescription: String?
    @NSManaged public var isDeletedElement: Bool
    @NSManaged public var pageImage: Data?
    @NSManaged public var parentCatalogue: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var catalogue: Catalogues?

}
