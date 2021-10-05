//
//  CatalogueElementTypeList.swift
//  AutoCataloguer
//
//  Created by Sergey on 21.09.2021.
//

import Foundation

enum CatalogueType: String, CaseIterable {
    case box = "Коробка"
    case shelf = "Полка"
    case file = "Папка"
    case bookcase = "Книжный шкаф"
    case otherCatalogueType = "Другое"
    
}



enum ElementType: CaseIterable {
    case book
    case letter
    case otherElementType
}

extension ElementType {
    public var elementDescription: String {
        switch self {
            
        case .book:
            return String("Книга")
        case .letter:
            return String("Письмо")
        case .otherElementType:
            return String("Другое")
        }
    }
}
