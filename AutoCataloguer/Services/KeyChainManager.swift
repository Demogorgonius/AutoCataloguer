//
//  KeyChainManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 07.09.2021.
//

import Foundation
import Security

protocol KeychainInputProtocol: AnyObject {
    
    func saveUserDataToKeychain(user: UserAuthData, completionBlock: @escaping(Result<Bool,Error>)-> Void)
    func loadUserDataFromKeychain(userEmail: String, completionBlock: @escaping(Result<UserAuthData, Error>)-> Void)
    
}

class KeychainManager: KeychainInputProtocol {
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    static let serverName = "autocataloguer.firebaseapp.com"
    
    func saveUserDataToKeychain(user: UserAuthData, completionBlock: @escaping(Result<Bool,Error>)-> Void) {
        
        let account = user.userEmail
        let userName = user.userName
        let password = user.userPassword.data(using: String.Encoding.utf8)!
        let uid = user.uid
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: KeychainManager.serverName,
                                    kSecValueData as String: password,
                                    kSecAttrLabel as String: userName,
                                    kSecAttrComment as String: uid]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            completionBlock(.success(true))
        } else {
            completionBlock(.failure(KeychainError.unhandledError(status: status)))
        }
        
    }
    
    func loadUserDataFromKeychain(userEmail: String, completionBlock: @escaping(Result<UserAuthData, Error>)-> Void) {
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: KeychainManager.serverName,
                                    kSecAttrAccount as String: userEmail,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        switch status {
        case errSecItemNotFound:
            completionBlock(.failure(KeychainError.noPassword))
        case errSecSuccess:
            guard let existingItem = item as? [String: Any],
                  let passwordData = existingItem[kSecValueData as String] as? Data,
                  let password = String(data: passwordData, encoding: String.Encoding.utf8),
                  let userName = existingItem[kSecAttrLabel as String] as? String,
                  let uid = existingItem[kSecAttrComment as String] as? String
            else {
                
                return completionBlock(.failure(KeychainError.unexpectedPasswordData))
            }
            let userData = UserAuthData(userName: userName, userEmail: userEmail, userPassword: password, uid: uid)
            completionBlock(.success(userData))
        
        default:
            completionBlock(.failure(KeychainError.unhandledError(status: status)))
        }
        
    }
    
}
