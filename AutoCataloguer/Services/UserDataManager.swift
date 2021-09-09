//
//  UserDataManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation

protocol UserDataManagerProtocol: AnyObject {
    func getUserNameFromUserDefaults() -> UserAuthData
    func saveUserToUserDefaults(user: UserAuthData)
    func deleteData(user: UserAuthData)
}

class UserDataManager: UserDataManagerProtocol {
    
    let defaults = UserDefaults.standard
    
    func getUserNameFromUserDefaults() -> UserAuthData {
        
        let user = UserAuthData(userName: defaults.string(forKey: "userName") ?? "Unregistered user",
                                userEmail: defaults.string(forKey: "userEmail") ?? "",
                                userPassword: "",
                                uid: "")
        return user
    }
    
    func saveUserToUserDefaults(user: UserAuthData) {
        defaults.set(user.userName, forKey: "userName")
        defaults.set(user.userEmail, forKey: "userEmail")
        defaults.set(user.uid, forKey: "uid")
    }
    
    func deleteData(user: UserAuthData) {
        defaults.set(nil, forKey: "userName")
        defaults.set(nil, forKey: "userEmail")
        defaults.set(nil, forKey: "uid")
        defaults.synchronize()
    }
    
}
