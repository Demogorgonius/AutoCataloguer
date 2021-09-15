//
//  SettingsViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    
    
    //MARK: - Variables
    
    var presenter: SettingsPresenterProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = loginButton.layer.bounds.height/2
        registerButton.layer.cornerRadius = registerButton.layer.bounds.height/2
        rememberButton.layer.cornerRadius = rememberButton.layer.bounds.height/2
        deleteUserButton.layer.cornerRadius = deleteUserButton.layer.bounds.height/2
        
    }

    //MARK: - IBAction
    
    @IBAction func loginTapped(_ sender: Any) {
        presenter.loginTapped()
    }

}





extension SettingsViewController: SettingsViewProtocol {
    func success(successType: SuccessType ,alert: UIAlertController?) {
        switch successType{
            
        case .loginOk:
            presenter.goToMainScreenIfSuccess()
        case .forgottenPassword:
            return
        case .registerOk:
            return
        case .deleteOk:
            return
        case .changePasswordOk:
            return
        case .alert:
            guard let alert = alert else { return }
            present(alert, animated: true)
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Ошибка!", message: error.localizedDescription), animated: true)
    }
    
    
}
