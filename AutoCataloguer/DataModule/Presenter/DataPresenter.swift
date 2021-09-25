//
//  DataPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import Foundation
import UIKit
import CoreData

enum DataViewSuccessType {
    case loadDataOk
    case contentTappOk
}

protocol DataPresenterViewProtocol: AnyObject {
    
    func success(successType: DataViewSuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol DataPresenterInputProtocol: AnyObject {
    
    init(view: DataPresenterViewProtocol,
         router: RouterInputProtocol,
         fireAuth: FireBaseAuthInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         validatorManager: ValidatorInputProtocol,
         keyChainManager: KeychainInputProtocol,
         userDataManager: UserDataManagerProtocol)
    func addTapped()
    func getCatalogues()
    func tapOnCatalogue(catalogue: Catalogues?)
    var catalogueModel: [Catalogues]? {get set}
    
}

class DataPresenterClass: DataPresenterInputProtocol {
    
    
    weak var view: DataPresenterViewProtocol?
    var router: RouterInputProtocol?
    var fireAuth: FireBaseAuthInputProtocol?
    var alertManager: AlertControllerManagerProtocol?
    var validatorManager: ValidatorInputProtocol?
    var keychainManager: KeychainInputProtocol?
    var userDataManager: UserDataManagerProtocol?
    var catalogueModel: [Catalogues]?
    
    
    required init(view: DataPresenterViewProtocol,
                  router: RouterInputProtocol,
                  fireAuth: FireBaseAuthInputProtocol,
                  alertManager: AlertControllerManagerProtocol,
                  validatorManager: ValidatorInputProtocol,
                  keyChainManager: KeychainInputProtocol,
                  userDataManager: UserDataManagerProtocol) {
        self.view = view
        self.router = router
        self.fireAuth = fireAuth
        self.alertManager = alertManager
        self.validatorManager = validatorManager
        self.keychainManager = keyChainManager
        self.userDataManager = userDataManager
        getCatalogues()
    }
    
    func tapOnCatalogue(catalogue: Catalogues?) {
        router?.showDataDetailViewController(catalogue: catalogue)
    }
    
    func addTapped() {
        
    }
    
    func getCatalogues() {
        
    }
    
    
}
