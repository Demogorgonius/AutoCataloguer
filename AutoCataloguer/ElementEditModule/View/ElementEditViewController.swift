//
//  ElementEditViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.01.2022.
//

import UIKit

class ElementEditViewController: UIViewController {

    var presenter: ElementEditProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ElementEditViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ElementEditViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        presenter.setElement()
       
    }
    
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
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "Edit element"
    }
    
    @objc func backButtonTapped() {
        presenter.goToBack()
    }
    
    @objc func saveTapped() {
        presenter.saveTapped()
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

extension ElementEditViewController: ElementEditViewProtocol {
    func setElement(element: Element?) {
        
    }
    
    func success(successType: ElementEditSuccessType, alert: UIAlertController?) {
        
    }
    
    func failure(error: Error) {
        
    }
    
    
}
