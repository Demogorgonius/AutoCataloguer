//
//  ScanViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import UIKit

class NewCatalogueViewController: UIViewController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var catalogueTypePicker: UIPickerView!
    @IBOutlet weak var catalogueName: UITextField!
    @IBOutlet weak var isFullSwitch: UISwitch!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var cataloguePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var cataloguePickerMarginTop: NSLayoutConstraint!
    
    //MARK: - Variables
    
    var presenter: NewCataloguePresenterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var catalogueType: String = CatalogueType.allCases[2].rawValue
    let defaultCatalogueType: Int = 2
    
    var catalogueTypePickerOpened: Bool = false
    let catalogueTypePickerHeightOpened: CGFloat = 214
    let catalogueTypePickerHeightClosed: CGFloat = 0
    let catalogueTypePickerMarginTopOpened: CGFloat = 0  // 18 (see below)
    let catalogueTypePickerMarginTopClosed: CGFloat = 0
    let animateTimeStd: TimeInterval = 0.5
    let animateTimeZero: TimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeButton.setTitle(catalogueType, for: .normal)
        showCatalogueTypePicker(show: false, animateTime: animateTimeZero)
        catalogueTypePicker.delegate = self
        catalogueTypePicker.dataSource = self
        catalogueTypePicker.selectRow(defaultCatalogueType, inComponent: 0, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCatalogueViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCatalogueViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        configureNavigationBar()
        
    }
    
    //MARK: IBAction
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if catalogueType == "" { catalogueType = CatalogueType.allCases[defaultCatalogueType].rawValue }
        presenter.saveButtonTapped(typeOfCatalogue: catalogueType,
                                   nameOfCatalogue: catalogueName.text ?? "",
                                   placeOfCatalogue: placeTextField.text ?? "",
                                   isFull: isFullSwitch.isOn)
    }
    
    @IBAction func typeTapped(_ sender: Any) {
        showCatalogueTypePicker(show: !catalogueTypePickerOpened, animateTime: animateTimeStd)
    }
    
    //MARK: - Methods
    
    
    func showCatalogueTypePicker(show: Bool, animateTime: TimeInterval) {
        catalogueTypePickerOpened = show
        
        self.catalogueTypePicker.isHidden = !show
        UIView.animate(withDuration: animateTime, animations: {
            self.cataloguePickerHeight.constant = (show ? self.catalogueTypePickerHeightOpened : self.catalogueTypePickerHeightClosed)
            self.cataloguePickerMarginTop.constant = (show ? self.catalogueTypePickerMarginTopOpened : self.catalogueTypePickerMarginTopClosed)
            self.view.layoutIfNeeded()
        })
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
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "New catalogue"
    }
    
    @objc func saveTapped() {
        saveButtonTapped(self)
    }
    
    @objc func backButtonTapped() {
        presenter.returnToDataView()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height/3
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

//MARK: - PickerView config

extension NewCatalogueViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CatalogueType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CatalogueType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        catalogueType = CatalogueType.allCases[row].rawValue
        typeButton.setTitle(CatalogueType.allCases[row].rawValue, for: .normal)
        showCatalogueTypePicker(show: false, animateTime: animateTimeStd)
    }
    
}

//MARK: - Extension viewController

extension NewCatalogueViewController: NewCatalogueViewProtocol {
    func success(successType: NewCatSuccessType, alert: UIAlertController?) {
        switch successType {
        case .saveOk:
            presenter.returnToDataView()
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
    }
    
    
}
