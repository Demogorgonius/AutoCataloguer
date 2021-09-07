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
    func createScanModule(router: RouterInputProtocol) -> UIViewController
    func createLoginModule(router: RouterInputProtocol) -> UIViewController
    
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
        let view = DataViewController()
        return view
    }
    
    func createSettingsModule(router: RouterInputProtocol) -> UIViewController {
        let view = SettingsViewController()
        return view
    }
    
    func createScanModule(router: RouterInputProtocol) -> UIViewController {
        let view = ScanViewController()
        return view
    }
    
    
}
