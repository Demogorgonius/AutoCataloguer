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
         elementPhotoType: ElementPhotoType,
         isEdit: Bool?)
    func setPhoto()
    func goToBack()
    func savePhoto(image: UIImage)
    func changePhotoTap()
    var isEdit: Bool? { get }
}

class PhotoModuleClass: PhotoModuleProtocol {
    weak var view: PhotoModuleViewProtocol!
    var router: RouterInputProtocol!
    var element: Element?
    var elementPhotoType: ElementPhotoType?
    var isEdit: Bool?
    
    required init(view: PhotoModuleViewProtocol,
                  router: RouterInputProtocol,
                  element: Element?,
                  elementPhotoType: ElementPhotoType,
                  isEdit: Bool?) {
        self.view = view
        self.router = router
        self.element = element
        self.elementPhotoType = elementPhotoType
        self.isEdit = isEdit
    }
    
    public func setPhoto() {
        self.view.setPhoto(element: element, elementPhotoType: elementPhotoType)
    }
    
    func savePhoto(image: UIImage) {
        switch elementPhotoType {
        case .firstPage:
            element?.pageImage = image.pngData()
        case .cover:
            element?.coverImage = image.pngData()
        case .none:
            return
        }
    }
    
    func changePhotoTap() {
        
    }
    
    func goToBack() {
        if isEdit == false {
            router.showElementDetailModule(element: element)
        } else {
            router.showElementEditModule(element: element)
        }
    }
    
    
}
