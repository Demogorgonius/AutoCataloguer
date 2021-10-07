//
//  EditCatalogueViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 05.10.2021.
//

import UIKit

class EditCatalogueViewController: UIViewController {

    var presenter: EditCataloguePresenterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var catalogueTypeLabel: UILabel!
    @IBOutlet weak var catalogueNameLabel: UILabel!
    @IBOutlet weak var cataloguePlaceTextField: UITextField!
    @IBOutlet weak var catalogueIsFullSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditCatalogueViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditCatalogueViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        presenter.setCatalogue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        configureNavigationBar()
        
    }


    //MARK: - IBAction
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        presenter.saveTapped(placeOfCatalogue: cataloguePlaceTextField.text ?? "", catalogueIsFull: catalogueIsFullSwitch.isOn)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        presenter.goBack()
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
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "Edit catalogue"
    }
    
    @objc func backButtonTapped() {
        presenter.goBack()
    }
    
    @objc func saveTapped() {
        presenter.saveTapped(placeOfCatalogue: cataloguePlaceTextField.text ?? "", catalogueIsFull: catalogueIsFullSwitch.isOn)
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

extension EditCatalogueViewController: EditCatalogueViewProtocol {
    func success(successType: EditCatalogueSuccessType, alert: UIAlertController?) {
        switch successType {
        case .saveOk:
            presenter.goBack()
        case .cancelEdit:
            presenter.cancelTapped()
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
    }
    
    func setCatalogue(catalogue: Catalogues?) {
        catalogueTypeLabel.text = catalogue?.typeOfCatalogue
        catalogueNameLabel.text = catalogue?.nameCatalogue
        catalogueIsFullSwitch.isOn = catalogue?.isFull ?? false
        cataloguePlaceTextField.text = catalogue?.placeOfCatalogue
    }
    
    
}
