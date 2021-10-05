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
         dataManager: DataManagerProtocol,
         validatorManager: ValidatorInputProtocol,
         catalogue: Catalogues?)
    func saveTapped()
    func cancelTapped()
    func goBack()
}

class EditCataloguePresenter: EditCataloguePresenterInputProtocol {
    weak var view: EditCatalogueViewProtocol?
    var router: RouterInputProtocol?
    var alertManager: AlertControllerManagerProtocol?
    var dataManager: DataManagerProtocol?
    var validatorManager: ValidatorInputProtocol?
    var catalogue: Catalogues?
    
    required init(view: EditCatalogueViewProtocol,
                  router: RouterInputProtocol,
                  alertManager: AlertControllerManagerProtocol,
                  dataManager: DataManagerProtocol,
                  validatorManager: ValidatorInputProtocol,
                  catalogue: Catalogues?) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        self.validatorManager = validatorManager
        self.catalogue = catalogue
    }
    
    
    
    func saveTapped() {
        
    }
    
    func cancelTapped() {
        router?.showDataViewController()
    }
    
    func goBack() {
        router?.showDataViewController()
    }
    
    
}
