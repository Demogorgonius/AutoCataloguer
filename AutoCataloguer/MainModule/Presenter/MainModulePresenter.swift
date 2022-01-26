//
//  MainModulePresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation

protocol MainModulePresenterInputProtocol: AnyObject {
    init(router: RouterInputProtocol, userDataManager: UserDataManagerProtocol)
    func newCatalogueTapped()
    func settingsButtonTapped()
    func showDataButtonTapped()
    func elementListButtonTapped()
    func setUserName() -> String
}

class MainModulePresenter: MainModulePresenterInputProtocol {
    
    var router: RouterInputProtocol?
    var userDataManager: UserDataManagerProtocol?
    
    required init(router: RouterInputProtocol, userDataManager: UserDataManagerProtocol) {
        self.router = router
        self.userDataManager = userDataManager
    }
    
    func newCatalogueTapped() {
        router?.showNewCatalogueViewController()
    }
    
    func settingsButtonTapped() {
        router?.showSettingsViewController()
    }
    
    func showDataButtonTapped() {
        router?.showDataViewController()
    }
    
    func elementListButtonTapped() {
        router?.showElementsViewController(display: .existing, catalogue: nil, indexOfCatalogue: 0)
    }
    
    func setUserName() -> String {
        let user = userDataManager?.getUserNameFromUserDefaults()
        let userName = user?.userName ?? ""
        return userName
    }
    
    
    
    
}
