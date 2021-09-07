//
//  Router.swift
//  AutoCataloguer
//
//  Created by Sergey on 02.09.2021.
//

import Foundation
import UIKit

protocol RouterOutputProtocol {
    
    var navigationVC: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
    
}

protocol RouterInputProtocol: RouterOutputProtocol {
    
    func showInitialViewController()
    func showSettingsViewController()
    func showDataViewController()
    func showScanViewController()
    func showLoginViewController()
    
}

class Router: RouterInputProtocol {
    
    var navigationVC: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationVC: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol){
        self.navigationVC = navigationVC
        self.assemblyBuilder = assemblyBuilder
    }
    
    func showInitialViewController() {
        if let navigationVC = navigationVC {
            guard let mainVC = assemblyBuilder?.createMainModule(router: self) else {return }
            navigationVC.viewControllers = [mainVC]
        }
    }
    
    func showLoginViewController() {
        
        if let navigationVC = navigationVC {
            guard let loginVC = assemblyBuilder?.createLoginModule(router: self) else { return }
            navigationVC.pushViewController(loginVC, animated: true)
        }
        
    }
    
    func showScanViewController() {
        
        if let navigationVC = navigationVC {
            guard let scanVC = assemblyBuilder?.createScanModule(router: self) else { return }
            navigationVC.pushViewController(scanVC, animated: true)
        }
        
    }
    
    func showSettingsViewController() {
        
        if let navigationVC = navigationVC {
            guard let settingsVC = assemblyBuilder?.createSettingsModule(router: self) else { return }
            navigationVC.pushViewController(settingsVC, animated: true)
        }
        
    }
    
    func showDataViewController() {
        
        if let navigationVC = navigationVC {
            guard let dataVC = assemblyBuilder?.createDataModule(router: self) else {return}
            navigationVC.pushViewController(dataVC, animated: true)
        }
        
    }
    
}


