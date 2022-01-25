//
//  ElementEditPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.01.2022.
//

import Foundation
import UIKit

enum ElementEditSuccessType {
    case loadDataOk
    case saveOk
    case cancelEditOk
}

protocol ElementEditViewProtocol: AnyObject {
    func setElement(element: Element?)
    func success(successType: ElementEditSuccessType, alert: UIAlertController?)
    func failure(error: Error)
}

protocol ElementEditProtocol: AnyObject {
    init(view: ElementEditViewProtocol,
         router: RouterInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         dataManager: DataManagerProtocol,
         validationManager: ValidatorInputProtocol,
         element: Element?
         )
    func saveTapped(description: String, elementCatalogue: String)
    func cancelTaped()
    func goToBack()
    func setElement()
    func getAllCataloguesName() -> [String]
    var catalogues: [Catalogues]? {get set}
}

class ElementEditPresenter: ElementEditProtocol {

    weak var view: ElementEditViewProtocol!
    var router: RouterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var dataManager: DataManagerProtocol!
    var validatorManager: ValidatorInputProtocol!
    var element: Element?
    var catalogues: [Catalogues]?
    var allCataloguesName: [String] = []
    
    required init(view: ElementEditViewProtocol, router: RouterInputProtocol, alertManager: AlertControllerManagerProtocol, dataManager: DataManagerProtocol, validationManager: ValidatorInputProtocol, element: Element?) {
        self.view = view
        self.router = router
        self.alertManager = alertManager
        self.dataManager = dataManager
        self.validatorManager = validationManager
        self.element = element
    }
    
    func saveTapped(description: String, elementCatalogue: String) {
        var coverImageFin: UIImage!
        
        if let coverImage = element?.coverImage {
            coverImageFin = UIImage(data: coverImage)
        }
        
        var firstPageImageFin: UIImage!
        
        if let firstPageImage = element?.pageImage {
            firstPageImageFin = UIImage(data: firstPageImage)
        }
        
        var catalogueToSave: Catalogues!
        
        dataManager.getCatalogue(catalogueName: elementCatalogue) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            
            case .success(let catalogue):
                catalogueToSave = catalogue
            case .failure(let error):
                self.view.failure(error: error)
                
            }
            
        }
       
        
        dataManager.saveElement(elementType: element?.type ?? "",
                                elementAuthor: element?.author ?? "",
                                elementRealiseDate: element?.releaseDate ?? "",
                                elementTitle: element?.title ?? "",
                                elementDescription: description,
                                elementParentCatalogue: elementCatalogue,
                                catalogue: catalogueToSave,
                                elementCoverPhoto: coverImageFin,
                                elementFirstPagePhoto: firstPageImageFin ?? nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.view.success(successType: .saveOk, alert: nil)
            case .failure(let error):
                self.view.failure(error: error)
            }
        }
        
    }
    
  
    
    func cancelTaped() {
        router.showElementDetailModule(element: element)
    }
    
    func goToBack() {
        router.showElementDetailModule(element: element)
    }
    
    public func setElement() {
        self.view.setElement(element: element)
    }
    
    func getAllCataloguesName() -> [String] {
        
        dataManager.getAllCatalogue { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let catalogues):
                self.catalogues = catalogues
            case .failure(let error):
                self.view.failure(error: error)
            }
        }
        for catalogue in catalogues! {
            print("name of catalogue is: \(catalogue.nameCatalogue!)")
            allCataloguesName.append(catalogue.nameCatalogue ?? "")
        }
        return allCataloguesName
        
    }
    
    
}
