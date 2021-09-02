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
    
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterInputProtocol) -> UIViewController {
        let view = MainViewController()
        return view
    }
    
    func createDataModule(router: RouterInputProtocol) -> UIViewController {
        <#code#>
    }
    
    func createSettingsModule(router: RouterInputProtocol) -> UIViewController {
        <#code#>
    }
    
    
}
