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



enum ElementType: String, CaseIterable {
    case book = "Книга"
    case letter = "Письмо"
    case otherElementType = "Другое"
}
