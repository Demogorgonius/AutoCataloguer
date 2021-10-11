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
    func success(successType: NewElementSuccessType, alert: UIAlertController?)
    func failure(error: Error)
}

protocol NewElementPresenterProtocol: AnyObject {
    var catalogue: Catalogues? { get set }
    func saveButtonTapped(elementType: String, elementAuthor: String, elementRealiseDate: String, elementTitle: String, elementDescription: String, elementParentCatalogue: String)
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
    
    func saveButtonTapped(elementType: String, elementAuthor: String, elementRealiseDate: String, elementTitle: String, elementDescription: String, elementParentCatalogue: String) {
        var validateResult: Bool = false
        do{
            validateResult = try validator.checkString(stringType: .emptyString, string: elementType, stringForMatching: nil)
            validateResult = try validator.checkString(stringType: .emptyString, string: elementAuthor, stringForMatching: nil)
            validateResult = try validator.checkString(stringType: .emptyString, string: elementTitle, stringForMatching: nil)
            validateResult = try validator.checkString(stringType: .emptyString, string: elementParentCatalogue, stringForMatching: nil)
        } catch {
            validateResult = false
            view.failure(error: error)
        }
        if validateResult == true {
            var catalogueOfElement: Catalogues!
            dataManager.getCatalogue(catalogueName: elementParentCatalogue) { [weak self] result in
                
                guard let self = self else { return }
                switch result {
                case .success(let catalogue):
                    catalogueOfElement = catalogue
                case .failure(let error):
                    self.view.failure(error: error)
                    
                }
                
            }
            dataManager.saveElement(elementType: elementType, elementAuthor: elementAuthor, elementRealiseDate: elementRealiseDate, elementTitle: elementTitle, elementDescription: elementDescription, elementParentCatalogue: elementParentCatalogue, catalogue: catalogueOfElement) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.view.success(successType: .saveOK, alert: nil)
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
        }
    }
    
    func returnToElementView() {
        router.showElementsViewController(catalogue: catalogue, indexOfCatalogue: 0)
    }
    
    
    
}
