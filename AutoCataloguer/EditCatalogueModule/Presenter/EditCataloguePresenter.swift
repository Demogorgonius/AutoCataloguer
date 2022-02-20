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
    
    func setCatalogue(catalogue: Catalogues?)
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
    func saveTapped(placeOfCatalogue: String, catalogueIsFull: Bool)
    func cancelTapped()
    func goBack()
    func setCatalogue()
}

class EditCataloguePresenter: EditCataloguePresenterInputProtocol {
    weak var view: EditCatalogueViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var validatorManager: ValidatorInputProtocol!
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
    
    public func setCatalogue() {
        self.view?.setCatalogue(catalogue: catalogue)
    }
    
    func saveTapped(placeOfCatalogue: String, catalogueIsFull: Bool) {
        
        var validatorResult: Bool = false
        
        do {
            validatorResult = try validatorManager.checkString(stringType: .emptyString, string: placeOfCatalogue, stringForMatching: nil)
        } catch {
            validatorResult = false
            view.failure(error: error)
        }
        
        if validatorResult == true {
            if catalogue != nil {
                    catalogue!.placeOfCatalogue = placeOfCatalogue
                    catalogue!.isFull = catalogueIsFull
                    dataManager.editCatalogue(catalogue: catalogue!) { [ weak self ] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(_):
                            self.view.success(successType: .saveOk, alert: nil)
                        case .failure(let error):
                            self.view.failure(error: error)
                        }
                    }
            }
//                }
                
            } else {
                return
            }
            
        }
        
    // }
    
    
    
    func cancelTapped() {
        router?.showDataViewController()
    }
    
    func goBack() {
        router?.showDataViewController()
    }
    
    
}
