//
//  PhotoPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 19.01.2022.
//

import Foundation
import UIKit

enum ElementPhotoType {
    case cover
    case firstPage
}

protocol PhotoModuleViewProtocol: AnyObject {
    func setPhoto(element: Element?, elementPhotoType: ElementPhotoType?)
}

protocol PhotoModuleProtocol: AnyObject {
    init(view: PhotoModuleViewProtocol,
         router: RouterInputProtocol,
         element: Element?,
         elementPhotoType: ElementPhotoType)
    func setPhoto()
    func goToBack()
}

class PhotoModuleClass: PhotoModuleProtocol {
    weak var view: PhotoModuleViewProtocol!
    var router: RouterInputProtocol!
    var element: Element?
    var elementPhotoType: ElementPhotoType?
    
    required init(view: PhotoModuleViewProtocol, router: RouterInputProtocol, element: Element?, elementPhotoType: ElementPhotoType) {
        self.view = view
        self.router = router
        self.element = element
        self.elementPhotoType = elementPhotoType
    }
    
    public func setPhoto() {
        self.view.setPhoto(element: element, elementPhotoType: elementPhotoType)
    }
    
    func goToBack() {
        router.showElementDetailModule(element: element)
    }
    
    
}
