//
//  NewElementViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 10.10.2021.
//

import UIKit

class NewElementViewController: UIViewController {

    //MARK: - Variables
    
    var presenter: NewElementPresenterProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var elementTypePicker: UIPickerView!
    @IBOutlet weak var elementNameTextField: UITextField!
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        
    }
    
    //MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Methods

    func configureNavigationBar() {
        let currentVC = navigationController?.visibleViewController
        let numberOfCurrentVC = navigationController?.viewControllers.firstIndex(of: currentVC!)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        let saveButton = UIBarButtonItem(image: .checkmark, style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.leftBarButtonItem = backButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.rightBarButtonItem = saveButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "New element"
    }
    
    @objc func saveTapped() {
        saveButtonTapped(self)
    }
    
    @objc func backButtonTapped() {
        presenter.returnToElementView()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height/2
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

//MARK: - Extensions


//MARK: - View extension
extension NewElementViewController: NewElementViewProtocol {
    
    func success(successType: NewElementSuccessType, alert: UIAlertController) {
        switch successType {
        case .saveOK:
            return
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!!!", message: error.localizedDescription), animated: true)
    }
    
    
}
