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
    func registerTapped(userName: String, email: String, password: String, confPassword: String)
    func rememberTapped(email: String)
    func deleteTapped(email: String, password: String)
    func goToMainScreenIfSuccess()
    
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
        
        let alert = alertManager?.showAlertAuthentication(title: "Вход", message: "Введите e-mail и пароль указанные при регистрации.", completionBlock: { (result, email, password) in
            switch result {
            case true:
                if let email = email {
                    do {
                        validateResult = try self.validator.checkString(stringType: .email, string: email)
                    } catch {
                        self.view?.failure(error: error)
                    }
                    if let password = password {
                        do {
                            validateResult = try self.validator.checkString(stringType: .password, string: password)
                        } catch {
                            self.view?.failure(error: error)
                        }
                    }
                    if validateResult == true {
                        self.login(email: email, password: password!)
                    }
                }
            case false:
                return
            }
        })
        view?.success(successType: .alert, alert: alert!)
        
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
    
    func registerTapped(userName: String, email: String, password: String, confPassword: String) {
        
    }
    
    func rememberTapped(email: String) {
        
    }
    
    func deleteTapped(email: String, password: String) {
        
    }
    
    func goToMainScreenIfSuccess() {
        router?.showInitialViewController()
    }
    
    
}
