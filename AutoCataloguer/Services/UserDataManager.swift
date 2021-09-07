//
//  UserDataManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation

protocol UserDataManagerProtocol {
    func getUserNameFromUserDefaults() -> String
}

class UserDataManager: UserDataManagerProtocol {
    
    let defaults = UserDefaults.standard
    
    func getUserNameFromUserDefaults() -> String {
        let userName = defaults.string(forKey: "UserName") ?? "Unregistered user"
        return userName
    }
    
}
