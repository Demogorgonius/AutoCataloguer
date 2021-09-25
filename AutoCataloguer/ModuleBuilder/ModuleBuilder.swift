//
//  ModuleBuilder.swift
//  AutoCataloguer
//
//  Created by Sergey on 02.09.2021.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterInputProtocol) -> UIViewController
    func createDataModule(router: RouterInputProtocol) -> UIViewController
    func createSettingsModule(router: RouterInputProtocol) -> UIViewController
    func createNewCatalogueModule(router: RouterInputProtocol) -> UIViewController
    func createLoginModule(router: RouterInputProtocol) -> UIViewController
    func createDataDetailModule(router: RouterInputProtocol) -> UIViewController
    
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createLoginModule(router: RouterInputProtocol) -> UIViewController {
        let view = LoginViewController()
        return view
    }
    
    func createMainModule(router: RouterInputProtocol) -> UIViewController {
        let userDataManager = UserDataManager()
        let presenter = MainModulePresenter(router: router, userDataManager: userDataManager)
        let view = MainViewController()
        view.presenter = presenter
        return view
    }
    
    func createDataModule(router: RouterInputProtocol) -> UIViewController {
        let fireBaseAuthManager = FireBaseAuthManager()
        let alertManager = AlertControllerManager()
        let keychainManager = KeychainManager()
        let userDataManager = UserDataManager()
        let validatorManager = ValidatorClass()
        let view = DataViewController()
        let presenter = DataPresenterClass(view: view, router: router,
                                           fireAuth: fireBaseAuthManager,
                                           alertManager: alertManager,
                                           validatorManager: validatorManager,
                                           keyChainManager: keychainManager,
                                           userDataManager: userDataManager)
        
        view.presenter = presenter
        view.alertManager = alertManager
        return view
    }
    
    func createDataDetailModule(router: RouterInputProtocol) -> UIViewController {
        let fireBaseAuthManager = FireBaseAuthManager()
        let alertManager = AlertControllerManager()
        let keychainManager = KeychainManager()
        let userDataManager = UserDataManager()
        let view = DataDetailViewController()
        
        
        return view
    }
    
    
    func createSettingsModule(router: RouterInputProtocol) -> UIViewController {
        let fireBaseAuthManager = FireBaseAuthManager()
        let alertManager = AlertControllerManager()
        let validatorManager = ValidatorClass()
        let keyChainManager = KeychainManager()
        let userDataManager = UserDataManager()
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view,
                                          router: router,
                                          fireAuth: fireBaseAuthManager,
                                          alertManager: alertManager,
                                          validatorManager: validatorManager,
                                          keyChainManager: keyChainManager,
                                          userDataManager: userDataManager)
        view.alertManager = alertManager
        view.presenter = presenter
        return view
    }
    
    func createNewCatalogueModule(router: RouterInputProtocol) -> UIViewController {
        let view = NewCatalogueViewController()
        return view
    }
    
    
}
