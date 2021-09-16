//
//  SettingsPresenter.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation
import UIKit

enum SuccessType {
    case loginOk
    case forgottenPassword
    case registerOk
    case deleteOk
    case changePasswordOk
    case alert
}

protocol SettingsViewProtocol: AnyObject {
    
    func success(successType: SuccessType, alert: UIAlertController?)
    func failure(error: Error)
    
}

protocol SettingsPresenterProtocol: AnyObject {
    
    init(view: SettingsViewProtocol,
         router: RouterInputProtocol,
         fireAuth: FireBaseAuthInputProtocol,
         alertManager: AlertControllerManagerProtocol,
         validatorManager: ValidatorInputProtocol,
         keyChainManager: KeychainInputProtocol,
         userDataManager: UserDataManagerProtocol)
    
    func loginTapped()
    func registerTapped()
    func rememberTapped()
    func deleteTapped()
    func changePasswordTapped()
    func goToMainScreenIfSuccess()
    func checkIsUserExist() -> Bool
    
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsViewProtocol?
    var router: RouterInputProtocol?
    var fireAuth: FireBaseAuthInputProtocol?
    var alertManager: AlertControllerManagerProtocol?
    var validator: ValidatorInputProtocol!
    var userAuthData: UserAuthData!
    var keyChainManager: KeychainInputProtocol!
    var userDataManager: UserDataManagerProtocol!
    
    required init(view: SettingsViewProtocol,
                  router: RouterInputProtocol,
                  fireAuth: FireBaseAuthInputProtocol,
                  alertManager: AlertControllerManagerProtocol,
                  validatorManager: ValidatorInputProtocol,
                  keyChainManager: KeychainInputProtocol,
                  userDataManager: UserDataManagerProtocol) {
        self.view = view
        self.router = router
        self.fireAuth = fireAuth
        self.alertManager = alertManager
        self.validator = validatorManager
        self.keyChainManager = keyChainManager
        self.userDataManager = userDataManager
    }
    
    func loginTapped() {
        
        var validateResult: Bool = false
        
        let alert = alertManager?.showAlertAuthentication(title: "Log In", message: "Please enter your e-mail and password.", completionBlock: { (result, email, password) in
            switch result {
            case true:
                if let email = email,
                   let password = password {
                    do {
                        validateResult = try self.validator.checkString(stringType: .email, string: email, stringForMatching: nil)
                        validateResult = try self.validator.checkString(stringType: .password, string: password, stringForMatching: nil)
                    } catch {
                        self.view?.failure(error: error)
                    }
                    
                    if validateResult == true {
                        self.login(email: email, password: password)
                    }
                }
            case false:
                return
            }
        })
        view?.success(successType: .alert, alert: alert)
        
    }
    
    func login(email: String, password: String)
    {
        fireAuth?.signIn(email: email, password: password, completionBlock: { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            
            case .success(let user):
                self.keyChainManager.saveUserDataToKeychain(user: user) { result in
                    switch result {
                    case .success(_):
                        self.userDataManager.saveUserToUserDefaults(user: user)
                        self.view?.success(successType: .loginOk, alert: nil)
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            case .failure(let error):
                self.view?.failure(error: error)
            }
            
        })
    }
    
    func registerTapped() {
        var validateResult: Bool = false
        
        let alert = alertManager?.showAlertRegistration(title: "Sign In", message: "Register new user in network service.", completionBlock: { (result, userName, email, password, confirmPassword) in
            
            switch result {
            case true:
                if let userName = userName,
                   let email = email,
                   let password = password,
                   let confirmPassword = confirmPassword {
                    do {
                        validateResult = try self.validator.checkString(stringType: .userName, string: userName, stringForMatching: nil)
                        validateResult = try self.validator.checkString(stringType: .email, string: email, stringForMatching: nil)
                        validateResult = try self.validator.checkString(stringType: .password, string: password, stringForMatching: nil)
                        validateResult = try self.validator.checkString(stringType: .password, string: confirmPassword, stringForMatching: nil)
                        validateResult = try self.validator.checkString(stringType: .passwordMatch, string: password, stringForMatching: confirmPassword)
                    } catch {
                        self.view?.failure(error: error)
                    }
                    
                    if validateResult == true {
                        self.registerNewUser(userName: userName, email: email, password: password)
                    }
                }
                
            case false:
                return
            }
            
        })
        view?.success(successType: .alert, alert: alert)
    }
    
    func registerNewUser(userName: String, email: String, password: String) {
        
        keyChainManager.deleteUserDataFromKeychain { result in
            switch result {
            
            case .success(_):
                return
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
        
        fireAuth?.createUser(userName: userName, email: email, password: password, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let user):
                self.keyChainManager.saveUserDataToKeychain(user: user) { result in
                    switch result {
                    case .success(_):
                        self.userDataManager.saveUserToUserDefaults(user: user)
                        self.view?.success(successType: .registerOk, alert: nil)
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            case .failure(let error):
                self.view?.failure(error: error)
            }
            
        })
        
    }
    
    func rememberTapped() {
        var validateResult: Bool = false
        let alert = alertManager?.showAlertRememberPassword(title: "Forgot password?", message: "Enter e-mail address and wait letter)", completionBlock: { (result, email) in
            switch result {
            case true:
                if let email = email {
                    do {
                        validateResult = try self.validator.checkString(stringType: .email, string: email, stringForMatching: nil)
                    } catch {
                        self.view?.failure(error: error)
                    }
                    if validateResult == true {
                        self.rememberPassword(email: email)
                    }
                }
                
            case false:
                return
            }
        })
        
        view?.success(successType: .alert, alert: alert)
        
    }
    
    func rememberPassword(email: String) {
        fireAuth?.restorePassword(email: email, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(_):
                self.view?.success(successType: .forgottenPassword, alert: nil)
            case .failure(let error):
                self.view?.failure(error: error)
            }
        })
    }
    
    func deleteTapped() {
        
    }
    
    func changePasswordTapped() {
        
    }
    
    func goToMainScreenIfSuccess() {
        router?.showInitialViewController()
    }
    
    func checkIsUserExist() -> Bool {
        var userToCheck: UserAuthData
        userToCheck = userDataManager.getUserNameFromUserDefaults()
        if userToCheck.userEmail == "" {
            return false
        } else {
            return true
        }
    }
    
    
}
