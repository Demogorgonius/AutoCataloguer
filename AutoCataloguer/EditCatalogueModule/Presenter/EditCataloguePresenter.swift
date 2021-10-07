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
         catalogue: Catalogues?,
         indexOfCatalogue: Int)
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
    var indexOfCatalogue: Int!
    
    required init(view: EditCatalogueViewProtocol,
                  router: RouterInputProtocol,
                  alertManager: AlertControllerManagerProtocol,
                  dataManager: DataManagerProtocol,
                  validatorManager: ValidatorInputProtocol,
                  catalogue: Catalogues?,
                  indexOfCatalogue: Int) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        self.validatorManager = validatorManager
        self.catalogue = catalogue
        self.indexOfCatalogue = indexOfCatalogue
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
            var allCatalogues: [Catalogues]!
            dataManager.getAllCatalogue { [ weak self ] result in
                
                guard let self = self else { return }
                switch result {
                    
                case .success(let catalogues):
                    allCatalogues = catalogues!
                case .failure(let error):
                    self.view.failure(error: error)
                }
                
            }
            
            if allCatalogues != nil {

                allCatalogues[indexOfCatalogue].placeOfCatalogue = placeOfCatalogue
                allCatalogues[indexOfCatalogue].isFull = catalogueIsFull
                dataManager.editCatalogue(catalogue: allCatalogues[indexOfCatalogue]) { [ weak self ] result in
                    guard let self = self else { return }
                    switch result {
                        
                    case .success(_):
                        self.view.success(successType: .saveOk, alert: nil)
                    case .failure(let error):
                        self.view.failure(error: error)
                    }
                }
                
            } else {
                return
            }
            
        }
        
    }
    
    
    
    func cancelTapped() {
        router?.showDataViewController()
    }
    
    func goBack() {
        router?.showDataViewController()
    }
    
    
}
