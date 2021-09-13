//
//  Element+CoreDataProperties.swift
//  
//
//  Created by Sergey on 13.09.2021.
//
//

import Foundation
import CoreData


extension Element {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Element> {
        return NSFetchRequest<Element>(entityName: "Element")
    }

    @NSManaged public var title: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var author: String?
    @NSManaged public var type: String?

}
