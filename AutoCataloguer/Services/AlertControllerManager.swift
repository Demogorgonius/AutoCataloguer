//
//  AlertControllerManager.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import Foundation
import UIKit

protocol AlertControllerManagerProtocol: AnyObject {
    
    func showAlert(title: String, message: String) -> UIAlertController
    func showAlertQuestion(title: String, message: String, completionBlock: @escaping(Bool) -> Void) -> UIAlertController
    func showAlertRegistration(title: String, message: String, completionBlock: @escaping(_ action: Bool, _ userName: String?, _ email: String?, _ password: String?, _ confPassword: String?) -> Void) -> UIAlertController
    func showAlertAuthentication(title: String, message: String, completionBlock: @escaping(_ action: Bool, _ email: String?, _ password: String?)-> Void) -> UIAlertController
    
}

class AlertControllerManager: AlertControllerManagerProtocol {
    
    //MARK: - Alert message
    
    func showAlert(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        return alert
        
    }
    
    //MARK: - Alert question
    
    func showAlertQuestion(title: String, message: String, completionBlock: @escaping (Bool) -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completionBlock(true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { action in
            completionBlock(false)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
        
    }
    
    //MARK: - Alert registration
    
    func showAlertRegistration(title: String, message: String, completionBlock: @escaping (Bool, String?, String?, String?, String?) -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .name
            textField.placeholder = "user name"
        }
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .emailAddress
            textField.placeholder = "e-mail"
        }
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .password
            textField.placeholder = "password"
        }
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .password
            textField.placeholder = "confirm password"
        }
        
        let okAction = UIAlertAction(title: "Зарегистрироваться", style: .default) { alertAction in
            let userName = alert.textFields![0] as UITextField
            let email = alert.textFields![1] as UITextField
            let password = alert.textFields![2] as UITextField
            let confPassword = alert.textFields![3] as UITextField
            completionBlock(true, userName.text, email.text, password.text, confPassword.text)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { alertAction in
            completionBlock(false, "", "", "", "")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
        
    }
    
    //MARK: - Alert authentication
    
    func showAlertAuthentication(title: String, message: String, completionBlock: @escaping (Bool, String?, String?) -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .emailAddress
            textField.placeholder = "e-mail"
        }
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .password
            textField.placeholder = "password"
        }
        
        let okAction = UIAlertAction(title: "Войти", style: .default) { alertAction in
            let email = alert.textFields![0] as UITextField
            let password = alert.textFields![1] as UITextField
            completionBlock(true, email.text, password.text)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { alertAction in
            completionBlock(false, "", "")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
        
    }
    
}
