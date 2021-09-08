//
//  MainModulePresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation

protocol MainModulePresenterInputProtocol: AnyObject {
    init(router: RouterInputProtocol, userDataManager: UserDataManagerProtocol)
    func scanButtonTapped()
    func settingsButtonTapped()
    func showDataButtonTapped()
    func setUserName() -> String
}

class MainModulePresenter: MainModulePresenterInputProtocol {
    
    var router: RouterInputProtocol?
    var userDataManager: UserDataManagerProtocol?
    
    required init(router: RouterInputProtocol, userDataManager: UserDataManagerProtocol) {
        self.router = router
        self.userDataManager = userDataManager
    }
    
    func scanButtonTapped() {
        router?.showScanViewController()
    }
    
    func settingsButtonTapped() {
        router?.showSettingsViewController()
    }
    
    func showDataButtonTapped() {
        router?.showDataViewController()
    }
    
    func setUserName() -> String {
        let user = userDataManager?.getUserNameFromUserDefaults()
        let userName = user?.userName ?? ""
        return userName
    }
    
    
    
    
}
