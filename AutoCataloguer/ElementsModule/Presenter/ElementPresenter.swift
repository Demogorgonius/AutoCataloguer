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
          indexOfCatalogue: Int,
          display: DisplayType)
    
    var catalogue: Catalogues? { get set }
    var elements: [Element]? { get set }
    func setElements()
    func deleteElement(element: Int)
    func editElement(element: Element?)
    func goToBack()
    func tapOnElement(element: Element?)
    func addElementTapped()
    func getElements(display: DisplayType)
}

class ElementsPresenterClass: ElementsPresenterInputProtocol {
    
    
    
    weak var view: ElementsPresenterViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var catalogue: Catalogues?
    var elements: [Element]?
    var indexOfCatalogue: Int!
    var display: DisplayType?
    
    required init(view: ElementsPresenterViewProtocol,
                  router: RouterInputProtocol,
                  alertManger: AlertControllerManagerProtocol,
                  dataManager: DataManagerProtocol,
                  catalogue: Catalogues?,
                  indexOfCatalogue: Int,
                  display: DisplayType) {
        self.view = view
        self.router = router
        self.alertManager = alertManger
        self.dataManager = dataManager
        self.catalogue = catalogue
        self.indexOfCatalogue = indexOfCatalogue
        self.display = display
        
    }
    
    func getElements(display: DisplayType) {
        if let catalogue = catalogue {
            dataManager.getElementsFromCatalogue(catalogue: catalogue, display: display) { [weak self] result in
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
            dataManager.getAllElements(display: display ) { [weak self] result in
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
            dataManager.getElementsFromCatalogue(catalogue: catalogue, display: .existing) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let elements):
                    self.elements = elements
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
            
        } else {
            dataManager.getAllElements(display: display ?? .existing) { [weak self] result in
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
    
    func deleteElement(element: Int) {
        if elements?[element].isDeletedElement == false {
            guard let markElement = elements?[element] else {return}
            dataManager.markElementAsDeleted(element: markElement) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.view.success(successType: .deleteOk, alert: nil)
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
        } else {
            dataManager.deleteElement(element: elements?[element]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.view.success(successType: .deleteOk, alert: nil)
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
        }
    }
    
    func editElement(element: Element?) {
        router.showElementEditModule(element: element)
    }
    
    func goToBack() {
        router.showDataViewController()
    }
    
    func tapOnElement(element: Element?) {
        router.showElementDetailModule(element: element)
    }
    
    func addElementTapped() {
        router.showNewElementViewController(catalogue: catalogue)
    }
    
}
