//
//  NewElementPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 10.10.2021.
//

import Foundation
import UIKit

enum NewElementSuccessType {
    case saveOK
}


protocol NewElementViewProtocol: AnyObject {
    func success(successType: NewElementSuccessType, alert: UIAlertController)
    func failure(error: Error)
}

protocol NewElementPresenterProtocol: AnyObject {
    var catalogue: Catalogues? { get set }
    func saveButtonTapped()
    func returnToElementView()
    init(view: NewElementViewProtocol,
         router: RouterInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         dataManager: DataManagerProtocol,
         validator: ValidatorInputProtocol,
         catalogue: Catalogues?)
}

class NewElementPresenter: NewElementPresenterProtocol {
    var catalogue: Catalogues?
    weak var view: NewElementViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var validator: ValidatorInputProtocol!
    required init(view: NewElementViewProtocol,
                  router: RouterInputProtocol,
                  alertManager: AlertControllerManagerProtocol,
                  dataManager: DataManagerProtocol,
                  validator: ValidatorInputProtocol,
                  catalogue: Catalogues?) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        self.validator = validator
        self.catalogue = catalogue
    }
    
    func saveButtonTapped() {
        
    }
    
    func returnToElementView() {
        router.showElementsViewController(catalogue: catalogue, indexOfCatalogue: 0)
    }
    
    
    
}
