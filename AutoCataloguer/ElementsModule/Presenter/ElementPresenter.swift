//
//  ElementPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import Foundation
import UIKit

enum ElementSuccessType {
    case saveOk
    case deleteOk
    case emptyData
    case elementTap
    case loadOk
}

protocol ElementsPresenterViewProtocol: AnyObject {
    
    func success(successType: ElementSuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol ElementsPresenterInputProtocol: AnyObject {
    init (view: ElementsPresenterViewProtocol,
          router: RouterInputProtocol,
          alertManger: AlertControllerManagerProtocol,
          dataManager: DataManagerProtocol,
          catalogue: Catalogues?,
          indexOfCatalogue: Int)
    
    var catalogue: Catalogues? { get set }
    var elements: [Element]? { get set }
    func setElements()
    func deleteElement()
    func goToBack()
    func tapElement()
    func addElementTapped()
    func getElements()
}

class ElementsPresenterClass: ElementsPresenterInputProtocol {

    
    
    weak var view: ElementsPresenterViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var catalogue: Catalogues?
    var elements: [Element]?
    var indexOfCatalogue: Int!
    
    required init(view: ElementsPresenterViewProtocol,
                  router: RouterInputProtocol,
                  alertManger: AlertControllerManagerProtocol,
                  dataManager: DataManagerProtocol,
                  catalogue: Catalogues?,
                  indexOfCatalogue: Int) {
        self.view = view
        self.router = router
        self.alertManager = alertManger
        self.dataManager = dataManager
        self.catalogue = catalogue
        self.indexOfCatalogue = indexOfCatalogue
        
    }
    
    func getElements() {
        if let catalogue = catalogue {
            dataManager.getElementsFromCatalogue(catalogue: catalogue) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let elements):
                    if elements.count == 0 {
                        self.view.success(successType: .emptyData, alert: nil)
                    } else {
                        self.elements = elements
                        self.view.success(successType: .loadOk, alert: nil)
                    }
                case .failure(let error):
                    self.view.failure(error: error)
                }
                
            }
        } else {
            dataManager.getAllElements { [weak self] result in
                guard let self = self else { return }
                switch result {
                    
                case .success(let elements):
                    self.elements = elements
                    self.view.success(successType: .loadOk, alert: nil)
                case .failure( let error):
                    self.view.failure(error: error)
                }
            }
        }
        
        
    }
    
    func setElements() {
        if let catalogue = catalogue {
            dataManager.getElementsFromCatalogue(catalogue: catalogue) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let elements):
                    self.elements = elements
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
            
        } else {
            dataManager.getAllElements { [weak self] result in
                guard let self = self else { return }
                switch result {
                    
                case .success(let elements):
                    self.elements = elements
                case .failure( let error):
                    self.view.failure(error: error)
                }
            }
        }
    }
    
    func deleteElement() {
        
    }
    
    func goToBack() {
        router.showDataViewController()
    }
    
    func tapElement() {
        
    }
    
    func addElementTapped() {
        router.showNewElementViewController(catalogue: catalogue)
    }
    
    
    
    
}
