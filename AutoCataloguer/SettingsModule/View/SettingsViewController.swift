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
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var userStatusLabel: UILabel!
    
    
    //MARK: - Variables
    
    var presenter: SettingsPresenterProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = loginButton.layer.bounds.height/2
        registerButton.layer.cornerRadius = registerButton.layer.bounds.height/2
        rememberButton.layer.cornerRadius = rememberButton.layer.bounds.height/2
        deleteUserButton.layer.cornerRadius = deleteUserButton.layer.bounds.height/2
        changePasswordButton.layer.cornerRadius = changePasswordButton.layer.bounds.height/2
        if presenter.checkIsUserExist() {
            disableButton()
        }
        
    }

    //MARK: - IBAction
    
    @IBAction func loginTapped(_ sender: Any) {
        presenter.loginTapped()
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        presenter.registerTapped()
    }
    
    @IBAction func rememberTapped(_ sender: Any) {
        presenter.rememberTapped()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        presenter.deleteTapped()
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        presenter.tempDeleteFromKeychain()
    }

    func disableButton() {
        loginButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        loginButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        registerButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        loginButton.isEnabled = false
        registerButton.isEnabled = false
        userStatusLabel.text = "User already registered"
        userStatusLabel.isHidden = false
    }
    
    func enableButton() {
        loginButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        loginButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        registerButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        registerButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        loginButton.isEnabled = true
        registerButton.isEnabled = true
        userStatusLabel.text = "Please login or register!"
        userStatusLabel.isHidden = false
    }
    
}





extension SettingsViewController: SettingsViewProtocol {
    func success(successType: SuccessType ,alert: UIAlertController?) {
        switch successType{
            
        case .loginOk:
            presenter.goToMainScreenIfSuccess()
        case .forgottenPassword:
            present(alertManager.showAlert(title: "Information", message: "Check your email! We send information for next step."), animated: true)
        case .registerOk:
            present(alertManager.showAlert(title: "Congratulations!", message: "You are registered!"), animated: true)
            disableButton()
        case .deleteOk:
            present(alertManager.showAlert(title: "Completed!", message: "User has been deleted!"), animated: true)
            enableButton()
        case .changePasswordOk:
            present(alertManager.showAlert(title: "Yeah!!!", message: "Keychain is clear!!!"), animated: true)
        case .alert:
            guard let alert = alert else { return }
            present(alert, animated: true)
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
    }
    
    
}
