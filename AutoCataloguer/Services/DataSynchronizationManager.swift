//
//  DataSynchronizationManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 25.09.2021.
//

import Foundation
import CoreData

protocol DataSynchronisationProtocol: AnyObject {
    func pushToServer(element: Element?, catalogue: Catalogues?, completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func getFromServer()
    
}
