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
    func showNewCatalogueViewController()
    func showLoginViewController()
    func showDataDetailViewController(catalogue: Catalogues?)
    func showEditCatalogue(catalogue: Catalogues?, indexOfCatalogue: Int)
    func showElementsViewController(display: DisplayType, catalogue: Catalogues?, indexOfCatalogue: Int)
    func showNewElementViewController(catalogue: Catalogues?)
    func showElementDetailModule(element: Element?)
    func showElementEditModule(element: Element?)
    func showPhotoModule(element: Element?, elementPhotoType: ElementPhotoType)
    func popToRoot()
    
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
    
    func showNewCatalogueViewController() {
        
        if let navigationVC = navigationVC {
            guard let newCatalogueVC = assemblyBuilder?.createNewCatalogueModule(router: self) else { return }
            navigationVC.pushViewController(newCatalogueVC, animated: true)
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
            guard let dataVC = assemblyBuilder?.createDataModule(router: self) else { return }
            navigationVC.pushViewController(dataVC, animated: true)
        }
        
    }
    
    func showEditCatalogue(catalogue: Catalogues?, indexOfCatalogue: Int) {
        if let navigationVC = navigationVC {
            guard let editCatalogueVC = assemblyBuilder?.createEditCatalogueModule(catalogue: catalogue, indexOfCatalogue: indexOfCatalogue, router: self) else { return }
            navigationVC.pushViewController(editCatalogueVC, animated: true)
        }
    }
    
    func showDataDetailViewController(catalogue: Catalogues?) {
        //        if let navigationVC = navigationVC {
        //            guard let dataDetailVC = assemblyBuilder?.createDataModule(router: self) else {return}
        //            navigationVC.pushViewController(dataDetailVC, animated: true)
        //        }
    }
    
    func showElementsViewController(display: DisplayType, catalogue: Catalogues?, indexOfCatalogue: Int) {
        
        if let navigationVC = navigationVC {
            guard let elementsVC = assemblyBuilder?.createElementsModule(display: display, catalogue: catalogue, indexOfCatalogue: indexOfCatalogue, router: self) else { return }
            navigationVC.pushViewController(elementsVC, animated: true)
        }
        
    }
    
    func showNewElementViewController(catalogue: Catalogues?) {
        
        if let navigationVC = navigationVC {
            guard let newElementVC = assemblyBuilder?.createNewElementModule(catalogue: catalogue, router: self) else { return }
            navigationVC.pushViewController(newElementVC, animated: true)
        }
        
    }
    
    func showElementDetailModule(element: Element?) {
        
        if let navigationVC = navigationVC {
            guard let elementDetailVC = assemblyBuilder?.createElementDetailModule(element: element, router: self) else { return }
            navigationVC.pushViewController(elementDetailVC, animated: true)
        }
        
    }
    
    func showElementEditModule(element: Element?) {
        
        if let navigationVC = navigationVC {
            guard let elementEditVC = assemblyBuilder?.createElementEditModule(element: element, router: self) else { return }
            navigationVC.pushViewController(elementEditVC, animated: true)
        }
        
    }
    
    func showPhotoModule(element: Element?, elementPhotoType: ElementPhotoType) {
        
        if let navigationVC = navigationVC {
            guard let photoVC = assemblyBuilder?.createPhotoModule(element: element, elementPhotoType: elementPhotoType, router: self) else { return }
            navigationVC.pushViewController(photoVC, animated: true)
        }
        
    }
    
    func popToRoot() {
        
        if let navigationVC = navigationVC {
            navigationVC.popToRootViewController(animated: true)
        }
        
    }
    
}


