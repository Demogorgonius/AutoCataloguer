//
//  ElementDetailPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import Foundation
import UIKit

enum ElementDetailSuccessType {
    case loadOk
    case changeOk
}

protocol ElementDetailViewProtocol: AnyObject  {
    
    func setElement(element: Element?)
    func success(successType: ElementDetailSuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol ElementDetailPresenterInputProtocol: AnyObject {
    
    init (view: ElementDetailViewProtocol,
         router: RouterInputProtocol,
         dataManager: DataManagerProtocol,
         alertManager: AlertControllerManagerProtocol,
         element: Element?)
    
    func goToBack()
    func editButtonTapped()
    
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
    
    func goToBack() {
        router.showDataViewController()
    }
    
    func editButtonTapped() {
        
    }
    
    
}
