//
//  NewCataloguePresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 21.09.2021.
//

import Foundation
import UIKit

enum NewCatSuccessType {
    case saveOk
}

protocol NewCatalogueViewProtocol: AnyObject {
    
    func success(successType: NewCatSuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol NewCataloguePresenterInputProtocol: AnyObject {
    
    init(view: NewCatalogueViewProtocol,
         router: RouterInputProtocol,
         validatorManager: ValidatorInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         dataManager: DataManagerProtocol)
    
    func saveButtonTapped(typeOfCatalogue: String, nameOfCatalogue: String, placeOfCatalogue: String, isFull: Bool)
    func returnToDataView()
    
}

class NewCataloguePresenterClass: NewCataloguePresenterInputProtocol {
    
    weak var view: NewCatalogueViewProtocol!
    var router: RouterInputProtocol!
    var validatorManager: ValidatorInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var newCatalogue: Catalogues!
    
    required init(view: NewCatalogueViewProtocol,
                  router: RouterInputProtocol,
                  validatorManager: ValidatorInputProtocol,
                  alertManager: AlertControllerManagerProtocol,
                  dataManager: DataManagerProtocol) {
        self.view = view
        self.router = router
        self.validatorManager = validatorManager
        self.alertManager = alertManager
        self.dataManager = dataManager
    }
    
    func saveButtonTapped(typeOfCatalogue: String, nameOfCatalogue: String, placeOfCatalogue: String, isFull: Bool) {
        var validateResult: Bool = false
        do {
            validateResult = try validatorManager.checkString(stringType: .emptyString, string: typeOfCatalogue, stringForMatching: nil)
            validateResult = try validatorManager.checkString(stringType: .emptyString, string: nameOfCatalogue, stringForMatching: nil)
            validateResult = try validatorManager.checkString(stringType: .emptyString, string: placeOfCatalogue, stringForMatching: nil)
        } catch {
            validateResult = false
            view.failure(error: error)
        }
        
        if validateResult == true {
            
            dataManager.saveCatalogue(catalogueName: nameOfCatalogue, catalogueType: typeOfCatalogue, cataloguePlace: placeOfCatalogue, catalogueIsFull: isFull) { [ weak self ]result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.view.success(successType: .saveOk, alert: nil)
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
        }
    }
    
    func returnToDataView() {
        router.showDataViewController()
    }
    
}
