//
//  ElementEditPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.01.2022.
//

import Foundation
import UIKit

enum ElementEditSuccessType {
    case loadDataOk
    case saveOk
    case cancelEditOk
}

protocol ElementEditViewProtocol: AnyObject {
    func setElement(element: Element?)
    func success(successType: ElementEditSuccessType, alert: UIAlertController?)
    func failure(error: Error)
}

protocol ElementEditProtocol: AnyObject {
    init(view: ElementEditViewProtocol,
         router: RouterInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         dataManager: DataManagerProtocol,
         validationManager: ValidatorInputProtocol,
         element: Element?
    )
    func saveTapped(description: String, elementCatalogue: String)
    func cancelTaped()
    func goToBack()
    func setElement()
    func getAllCataloguesName() -> [String]
    var catalogues: [Catalogues]? {get set}
}

class ElementEditPresenter: ElementEditProtocol {
    
    weak var view: ElementEditViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var validatorManager: ValidatorInputProtocol!
    var element: Element?
    var catalogues: [Catalogues]?
    var allCataloguesName: [String] = []
    
    required init(view: ElementEditViewProtocol, router: RouterInputProtocol, alertManager: AlertControllerManagerProtocol, dataManager: DataManagerProtocol, validationManager: ValidatorInputProtocol, element: Element?) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        self.validatorManager = validationManager
        self.element = element
    }
    
    func saveTapped(description: String, elementCatalogue: String) {
        
        guard let element = element else {
            return
        }
        
        dataManager.editElement(element: element, parentCatalogue: elementCatalogue, description: description) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let newElement):
                self.element = newElement
                self.view.success(successType: .saveOk, alert: nil)
            case .failure(let error):
                self.view.failure(error: error)
            }
            
        }
        
    }
    
    
    
    func cancelTaped() {
        router.showElementDetailModule(element: element)
    }
    
    func goToBack() {
        
        var allNewElements: [Element]!
        dataManager.getAllElements(display: .allElement) { result in
            switch result {
            case .success(let elements):
                allNewElements = elements
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        guard let oldID = element?.objectID.description.components(separatedBy: "<").last?.components(separatedBy: ">").first else {return}
        for elem in allNewElements {
            
            guard let id = elem.objectID.description.components(separatedBy: "<").last?.components(separatedBy: ">").first else { return }
            if oldID == id {
                element = elem
            }
            
        }
        
        router.showElementDetailModule(element: element)
        
    }
    
    public func setElement() {
        self.view.setElement(element: element)
    }
    
    func getAllCataloguesName() -> [String] {
        
        dataManager.getAllCatalogue { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let catalogues):
                self.catalogues = catalogues
            case .failure(let error):
                self.view.failure(error: error)
            }
        }
        for catalogue in catalogues! {
            allCataloguesName.append(catalogue.nameCatalogue ?? "")
        }
        return allCataloguesName
        
    }
    
    
}
