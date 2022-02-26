//
//  ElementDetailPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import Foundation
import UIKit



protocol ElementDetailViewProtocol: AnyObject  {
    
    func setElement(element: Element?)
   
}

protocol ElementDetailPresenterInputProtocol: AnyObject {
    
    init (view: ElementDetailViewProtocol,
         router: RouterInputProtocol,
         dataManager: DataManagerProtocol,
         alertManager: AlertControllerManagerProtocol,
         element: Element?)
    
    func goToBack()
    func editButtonTapped()
    func setElement()
    func coverButtonTapped()
    func firstPageButtonTapped()
    
}

class ElementDetailClass: ElementDetailPresenterInputProtocol {
    
    weak var view: ElementDetailViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var element: Element?
    
    
    required init(view: ElementDetailViewProtocol,
                  router: RouterInputProtocol,
                  dataManager: DataManagerProtocol,
                  alertManager: AlertControllerManagerProtocol, element: Element?) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        self.element = element
    }
    
    public func setElement() {
        self.view?.setElement(element: element)
    }
    
    func goToBack() {
        router.showElementsViewController(display: .existing, catalogue: element?.catalogue, indexOfCatalogue: 0)
    }
    
    func editButtonTapped() {
        router.showElementEditModule(element: element)
    }
    
    func coverButtonTapped() {
        router.showPhotoModule(element: element, elementPhotoType: .cover, isEdit: false)
    }
    
    func firstPageButtonTapped() {
        router.showPhotoModule(element: element, elementPhotoType: .firstPage, isEdit: false)
    }
    
    
}
