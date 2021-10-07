//
//  ModuleBuilder.swift
//  AutoCataloguer
//
//  Created by Sergey on 02.09.2021.
//

import Foundation
import UIKit
import CoreData

protocol AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterInputProtocol) -> UIViewController
    func createDataModule(router: RouterInputProtocol) -> UIViewController
    func createSettingsModule(router: RouterInputProtocol) -> UIViewController
    func createNewCatalogueModule(router: RouterInputProtocol) -> UIViewController
    func createLoginModule(router: RouterInputProtocol) -> UIViewController
    func createDataDetailModule(router: RouterInputProtocol) -> UIViewController
    func createEditCatalogueModule(catalogue: Catalogues?, indexOfCatalogue: Int, router: RouterInputProtocol) -> UIViewController
    func createElementModule(catalogue: Catalogues?, router: RouterInputProtocol) -> UIViewController
    
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
//        let fireBaseAuthManager = FireBaseAuthManager()
        let alertManager = AlertControllerManager()
//        let keychainManager = KeychainManager()
//        let userDataManager = UserDataManager()
//        let validatorManager = ValidatorClass()
        let coreDataManager = CoreDataManager()
        let context = coreDataManager.context
        let dataManager = DataManagerClass(context: context)
        let view = DataViewController()
        let presenter = DataPresenterClass(view: view, router: router, alertManager: alertManager, dataManager: dataManager)
        
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
        
        let validatorManager = ValidatorClass()
        let alertController = AlertControllerManager()
        let coreDataManager = CoreDataManager()
        let context = coreDataManager.context
        let dataManager = DataManagerClass(context: context)
        let view = NewCatalogueViewController()
        let presenter = NewCataloguePresenterClass(view: view, router: router, validatorManager: validatorManager, alertManager: alertController, dataManager: dataManager)
        view.presenter = presenter
        view.alertManager = alertController
        return view
        
    }
    
    func createEditCatalogueModule(catalogue: Catalogues?, indexOfCatalogue: Int, router: RouterInputProtocol) -> UIViewController {
        let coreDataManager = CoreDataManager()
        let context = coreDataManager.context
        let dataManager = DataManagerClass(context: context)
        let alertManager = AlertControllerManager()
        let validatorManager = ValidatorClass()
        let view = EditCatalogueViewController()
        let presenter = EditCataloguePresenter(view: view,
                                               router: router,
                                               alertManager: alertManager,
                                               dataManager: dataManager,
                                               validatorManager: validatorManager,
                                               catalogue: catalogue,
                                               indexOfCatalogue: indexOfCatalogue)
        view.presenter = presenter
        view.alertManager = alertManager
        return view
    }
    
    func createElementModule(catalogue: Catalogues?, router: RouterInputProtocol) -> UIViewController {
        let view = ElementViewController()
        return view
    }
    
}
