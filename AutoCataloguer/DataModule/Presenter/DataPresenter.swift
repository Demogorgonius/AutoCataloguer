//
//  DataPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import Foundation
import UIKit
import CoreData

enum DataViewSuccessType {
    case loadDataOk
    case contentTappOk
    case deleteOk
    case emptyData
    case showAlert
}

protocol DataPresenterViewProtocol: AnyObject {
    
    func success(successType: DataViewSuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol DataPresenterInputProtocol: AnyObject {
    
    init(view: DataPresenterViewProtocol,
         router: RouterInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         dataManager: DataManagerProtocol)
    func addTapped()
    func getCatalogues()
    func tapOnCatalogue(catalogue: Catalogues?, indexOfCatalogue: Int)
    func deleteCatalogue(catalogue: Catalogues)
    var catalogues: [Catalogues]? {get set}
    func backButtonTapped()
    func editCatalogue(catalogue: Catalogues?, indexOfCatalogue: Int)
    func setCatalogues()
    
}

class DataPresenterClass: DataPresenterInputProtocol {
    
    
    weak var view: DataPresenterViewProtocol?
    var router: RouterInputProtocol?
    var alertManager: AlertControllerManagerProtocol?
    var dataManager: DataManagerProtocol!
    var catalogues: [Catalogues]?
    
    
    required init(view: DataPresenterViewProtocol, router: RouterInputProtocol, alertManager: AlertControllerManagerProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        //    getCatalogues()
    }
    
    func tapOnCatalogue(catalogue: Catalogues?, indexOfCatalogue: Int) {
        
        router?.showElementsViewController(display: .existing, catalogue: catalogue, indexOfCatalogue: indexOfCatalogue)
        
    }
    
    func addTapped() {
        router?.showNewCatalogueViewController()
    }
    
    func getCatalogues() {
        dataManager?.getAllCatalogue(completionBlock: { [ weak self ] result in
            guard let self = self else { return }
            //            DispatchQueue.main.sync {
            switch result {
            case .success(let catalogues):
                if catalogues?.count == 0 {
                    self.view?.success(successType: .emptyData, alert: nil)
                } else {
                    self.catalogues = catalogues
                    self.view?.success(successType: .loadDataOk, alert: nil)
                }
            case .failure(let error):
                self.view?.failure(error: error)
            }
            //            }
        })
    }
    
    func deleteCatalogue(catalogue: Catalogues) {
        
        let alert = alertManager?.showAlertQuestion(title: "Delete!", message: "Do you want do delete this?", completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result{
            case true:
                deletingCatalogue(catalogueToDelete: catalogue)
            case false:
                self.view?.success(successType: .emptyData, alert: nil)
            }
            
        })
        
        self.view?.success(successType: .showAlert, alert: alert)
        
        func deletingCatalogue(catalogueToDelete: Catalogues) {
           
            if catalogues != nil {
                let index = (catalogues?.firstIndex(of: catalogueToDelete))!
                catalogues?.remove(at: index)
            }
            dataManager.deleteCatalogue(catalogue: catalogueToDelete) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.view?.success(successType: .deleteOk, alert: nil)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
        
        
//        var cataloguesToDelete: Catalogues!
//        dataManager.getAllCatalogue { [ weak self ] result in
//            guard let self = self else { return }
//            switch result {
//
//            case .success(let catalogues):
//                cataloguesToDelete = catalogues?[indexPath.row]
//            case .failure(let error):
//                self.view?.failure(error: error)
//            }
//        }
//        dataManager.deleteCatalogue(catalogue: cataloguesToDelete) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(_):
//                self.view?.success(successType: .deleteOk, alert: nil)
//            case .failure(let error):
//                self.view?.failure(error: error)
//            }
//        }
    }
    
    func setCatalogues() {
        dataManager.getAllCatalogue { [ weak self ] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let catalogues):
                self.catalogues = catalogues
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }
    
    func editCatalogue(catalogue: Catalogues?, indexOfCatalogue: Int) {
        router?.showEditCatalogue(catalogue: catalogue, indexOfCatalogue: indexOfCatalogue)
    }
    
    func backButtonTapped() {
        router?.popToRoot()
    }
    
    
}
