//
//  Catalogues+CoreDataProperties.swift
//  
//
//  Created by Sergey on 13.09.2021.
//
//

import Foundation
import CoreData


extension Catalogues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catalogues> {
        return NSFetchRequest<Catalogues>(entityName: "Catalogues")
    }

    @NSManaged public var typeOfCatalogue: String?
    @NSManaged public var placeOfCatalogue: String?
    @NSManaged public var isFull: Bool
    @NSManaged public var relationship: Element?

}
