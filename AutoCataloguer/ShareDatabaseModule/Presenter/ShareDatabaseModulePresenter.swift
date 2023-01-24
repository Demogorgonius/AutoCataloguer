//
//  ShareDatabaseModulePresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 29.11.2022.
//

import Foundation

protocol ShareDataBaseViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol ShareDataBaseModuleProtocol: AnyObject {
    
    init(view: ShareDataBaseViewProtocol,
         router: RouterInputProtocol,
         fireAuth: FireBaseAuthInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         validatorManager: ValidatorInputProtocol,
         keyChainManager: KeychainInputProtocol,
         userDataManager: UserDataManagerProtocol)
    func shareDatabaseTap()
    func importDataBaseFromGoogleTap()
    func exportDataBaseToGoogleTap()
    func goToBackTapped()
    
}

class ShareDataBaseClass: ShareDataBaseModuleProtocol {
    
    weak var view: ShareDataBaseViewProtocol?
    var router: RouterInputProtocol?
    var fireAuth: FireBaseAuthInputProtocol?
    var alertManager: AlertControllerManagerProtocol?
    var validator: ValidatorInputProtocol!
    var userAuthData: UserAuthData!
    var keyChainManager: KeychainInputProtocol!
    var userDataManager: UserDataManagerProtocol!
    
    required init(view: ShareDataBaseViewProtocol,
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
        self.validator = validatorManager
        self.keyChainManager = keyChainManager
        self.userDataManager = userDataManager
    }
    
    func shareDatabaseTap() {
        
        if checkUserIsRegister() == false {
            view?.failure(error: ValidateInputError.notRegisterUser)
        } else {
            router?.showInitialViewController()
        }
    }
    
    func importDataBaseFromGoogleTap() {
       
        if checkUserIsRegister() == false {
            view?.failure(error: ValidateInputError.notRegisterUser)
        } else {
            router?.showInitialViewController()
        }
        
    }
    
    func exportDataBaseToGoogleTap() {
        
        if checkUserIsRegister() == false {
            view?.failure(error: ValidateInputError.notRegisterUser)
        } else {
            router?.showInitialViewController()
        }
        
    }
    
    func goToBackTapped() {
        router?.showSettingsViewController()
    }
    
    func checkUserIsRegister() -> Bool {
        
        let user = userDataManager.getUserNameFromUserDefaults()
        if user.userName == "Unregistered user" {
            return false
        } else {
            return true
        }
    }
    
    
}
