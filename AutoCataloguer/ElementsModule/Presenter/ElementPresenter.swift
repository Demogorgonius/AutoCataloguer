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
    case showAlert
}

protocol ElementsPresenterViewProtocol: AnyObject {
    
    func success(successType: ElementSuccessType, alert: UIAlertController?, index: IndexPath?)
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
    func deleteElement(elementIndex: IndexPath)
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
        self.display = display
        if let catalogue = catalogue {
            dataManager.getElementsFromCatalogue(catalogue: catalogue, display: display) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let elements):
                    if elements.count == 0 {
                        self.elements = []
                        self.view.success(successType: .emptyData, alert: nil, index: nil)
                    } else {
                        self.elements = elements
                        self.view.success(successType: .loadOk, alert: nil, index: nil)
                        self.display = display
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
                    self.view.success(successType: .loadOk, alert: nil, index: nil)
                case .failure( let error):
                    self.view.failure(error: error)
                }
            }
        }
        
        
    }
    
    func setElements() {
        if let catalogue = catalogue {
            let display = display ?? .existing
            dataManager.getElementsFromCatalogue(catalogue: catalogue, display: display) { [weak self] result in
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
    
    func deleteElement(elementIndex: IndexPath) {
        
        let alert = alertManager.showAlertQuestion(title: "Delete!", message: "Do you want to delete this?") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case true:
                deletingElement(element: elementIndex)
            case false:
                self.view.success(successType: .emptyData, alert: nil, index: nil)
            }
        }
        
        view.success(successType: .showAlert, alert: alert, index: nil)
        
        func deletingElement(element: IndexPath) {
            
            dataManager.deleteElement(element: elements?[elementIndex.row]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.getElements(display: self.display ?? .existing)
                   // self.view.success(successType: .deleteOk, alert: nil, index: elementIndex)
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
