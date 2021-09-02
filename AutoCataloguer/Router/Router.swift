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
    
    func showSettingsViewController() {
    }
    
    func showDataViewController() {
    }
    
}


