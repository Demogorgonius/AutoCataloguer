//
//  EditCataloguePresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 05.10.2021.
//

import Foundation
import UIKit

enum EditCatalogueSuccessType {
    case saveOk
    case cancelEdit
}

protocol EditCatalogueViewProtocol: AnyObject {
    
    func success(successType: EditCatalogueSuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol EditCataloguePresenterInputProtocol: AnyObject {
    init(view: EditCatalogueViewProtocol,
         router: RouterInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         dataManager: DataManagerProtocol)
    func saveTapped()
    var catalogue: Catalogues { get set }
}
