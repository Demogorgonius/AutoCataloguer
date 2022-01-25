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
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var elementNameLabel: UILabel!
    @IBOutlet weak var elementTypeLabel: UILabel!
    @IBOutlet weak var elementDescriptionLabel: UITextView!
    @IBOutlet weak var elementAuthorLabel: UILabel!
    @IBOutlet weak var elementParentCataloguePikerView: UIPickerView!
    @IBOutlet weak var elementRealiseDateLabel: UILabel!
    @IBOutlet weak var elementCataloguePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var elementCataloguePickerMarginTop: NSLayoutConstraint!
    @IBOutlet weak var elementCatalogueButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Variables
    
    var elementCataloguePickerOpened: Bool = false
    let elementCataloguePickerHeightOpened: CGFloat = 214
    let elementCataloguePickerHeightClosed: CGFloat = 0
    let elementCataloguePickerMarginTopOpened: CGFloat = 0  // 18 (see below)
    let elementCataloguePickerMarginTopClosed: CGFloat = 0
    let animateTimeStd: TimeInterval = 0.5
    let animateTimeZero: TimeInterval = 0.0
    var allCataloguesNames: [String] = []
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ElementEditViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ElementEditViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        showCatalogueTypePicker(show: false, animateTime: animateTimeZero)
        presenter.setElement()
        allCataloguesNames = presenter.getAllCataloguesName()
        
    }
    
    //MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        configureNavigationBar()
        
    }
    
    //MARK: - IBActions
    
    @IBAction func catalogueButtonTapped(_ sender: Any) {
        showCatalogueTypePicker(show: !elementCataloguePickerOpened, animateTime: animateTimeStd)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        presenter.saveTapped(description: elementDescriptionLabel.text, elementCatalogue: elementCatalogueButton.title(for: .normal) ?? "")
    }
    
    //MARK: - Methods
    
    func showCatalogueTypePicker(show: Bool, animateTime: TimeInterval) {
        elementCataloguePickerOpened = show
        
        self.elementParentCataloguePikerView.isHidden = !show
        UIView.animate(withDuration: animateTime, animations: {
            self.elementCataloguePickerHeight.constant = (show ? self.elementCataloguePickerHeightOpened : self.elementCataloguePickerHeightClosed)
            self.elementCataloguePickerMarginTop.constant = (show ? self.elementCataloguePickerMarginTopOpened : self.elementCataloguePickerMarginTopClosed)
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
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "Edit element"
    }
    
    @objc func backButtonTapped() {
        presenter.goToBack()
    }
    
    @objc func saveTapped() {
        presenter.saveTapped(description: elementDescriptionLabel.text, elementCatalogue: elementCatalogueButton.title(for: .normal) ?? "")
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

//MARK: - PickerView Extension

extension ElementEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCataloguesNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCataloguesNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        elementCatalogueButton.setTitle(allCataloguesNames[row], for: .normal)
        showCatalogueTypePicker(show: false, animateTime: animateTimeStd)
    }
    
    
}

//MARK: - View Extension

extension ElementEditViewController: ElementEditViewProtocol {
    func setElement(element: Element?) {
        
        elementNameLabel.text = element?.title
        elementTypeLabel.text = element?.type
        elementDescriptionLabel.text = element?.elementDescription
        elementAuthorLabel.text = element?.author
        elementCatalogueButton.setTitle(element?.parentCatalogue, for: .normal)
        elementRealiseDateLabel.text = element?.releaseDate
        
    }
    
    func success(successType: ElementEditSuccessType, alert: UIAlertController?) {
        
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!!!", message: error.localizedDescription), animated: true)
    }
    
    
}
