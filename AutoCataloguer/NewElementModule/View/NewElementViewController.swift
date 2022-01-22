//
//  NewElementViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 10.10.2021.
//

import UIKit

class NewElementViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: - Variables
    
    var presenter: NewElementPresenterProtocol!
    var alertManager: AlertControllerManagerProtocol!
    var elementType: String = ElementType.allCases[1].rawValue
    var elementDefaultType: Int = 1
    var catalogue: Catalogues!
    var imagePicker = UIImagePickerController()
    
    var typePickerOpened: Bool = false
    var cataloguePickerOpened: Bool = false
    let pickerHeightOpened: CGFloat = 155
    let pickerHeightClosed: CGFloat = 0
    let pickerMarginTopOpened: CGFloat = 0
    let pickerMarginTopClosed: CGFloat = 0
    let animateTimeStd: TimeInterval = 0.5
    let animateTimeZero: TimeInterval = 0.0
    let labelMarginTopOpened: CGFloat = 186
    let buttonMarginTopOpened: CGFloat = 168
    var coverPhotoButtonIsTapped: Bool = false
    var firstPagePhotoButtonIsTapped: Bool = false
    
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var elementTypePicker: UIPickerView!
    @IBOutlet weak var elementTitleTextField: UITextField!
    @IBOutlet weak var elementCataloguePicker: UIPickerView!
    @IBOutlet weak var elementAuthorTextField: UITextField!
    @IBOutlet weak var elementDescriptionTextView: UITextView!
    @IBOutlet weak var elementTypeButton: UIButton!
    @IBOutlet weak var elementCatalogueButton: UIButton!
    @IBOutlet weak var elementRealiseDateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleCameraButton: UIButton!
    @IBOutlet weak var elementTypePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var elementCataloguePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var elementTypePickerMarginTop: NSLayoutConstraint!
    @IBOutlet weak var elementCataloguePickerMarginTop: NSLayoutConstraint!
    @IBOutlet weak var catalogueLabelMarginTop: NSLayoutConstraint!
    @IBOutlet weak var catalogueButtonMarginTop: NSLayoutConstraint!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var firstPagePhotoImageView: UIImageView!
    @IBOutlet weak var coverPhotoButton: UIButton!
    @IBOutlet weak var firstPagePhotoButton: UIButton!
    
    
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getAllCatalogue()
        elementTypeButton.setTitle(elementType, for: .normal)
        elementCatalogueButton.setTitle(presenter.catalogue?.nameCatalogue, for: .normal)
        showPickerView(pickerView: elementTypePicker,
                       pickerViewHeightConstraint: elementTypePickerHeight,
                       pickerViewMarginTopConstraint: elementTypePickerMarginTop,
                       show: false,
                       animateTime: animateTimeZero)
        showPickerView(pickerView: elementCataloguePicker,
                       pickerViewHeightConstraint: elementCataloguePickerHeight,
                       pickerViewMarginTopConstraint: elementCataloguePickerMarginTop,
                       show: false,
                       animateTime: animateTimeZero)
        
        elementTypePicker.selectRow(elementDefaultType, inComponent: 0, animated: true)
        elementCataloguePicker.selectRow(0, inComponent: 0, animated: true)
        elementDescriptionTextView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        elementDescriptionTextView.layer.borderWidth = 0.5
        elementDescriptionTextView.layer.cornerRadius = elementDescriptionTextView.layer.bounds.height/10
        elementDescriptionTextView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        elementDescriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        configureNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(NewCatalogueViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCatalogueViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        
    }
    
    //MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        presenter.saveButtonTapped(elementType: elementType,
                                   elementAuthor: elementAuthorTextField.text ?? "",
                                   elementRealiseDate: elementRealiseDateTextField.text ?? "",
                                   elementTitle: elementTitleTextField.text ?? "",
                                   elementDescription: elementDescriptionTextView.text ?? "",
                                   elementParentCatalogue: presenter.catalogue?.nameCatalogue ?? "",
                                   elementCoverPhoto: coverPhotoImageView.image,
                                   elementFirstPagePhoto: firstPagePhotoImageView.image)
    }
    
    @IBAction func elementTypeButtonTapped(_ sender: Any) {
        showPickerView(pickerView: elementTypePicker,
                       pickerViewHeightConstraint: elementTypePickerHeight,
                       pickerViewMarginTopConstraint: elementTypePickerMarginTop,
                       show: !typePickerOpened,
                       animateTime: animateTimeStd)
    }
    
    @IBAction func elementCatalogueButtonTapped(_ sender: Any) {
        showPickerView(pickerView: elementCataloguePicker,
                       pickerViewHeightConstraint: elementCataloguePickerHeight,
                       pickerViewMarginTopConstraint: elementCataloguePickerMarginTop,
                       show: !cataloguePickerOpened,
                       animateTime: animateTimeStd)
    }
    
    @IBAction func titleCameraButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func coverPhotoButtonTapped(_ sender: Any) {
        
        coverPhotoButtonIsTapped = true
        showPhotoAlertController()
    }
    
    @IBAction func firstPagePhotoButtonTapped(_ sender: Any) {
        firstPagePhotoButtonIsTapped = true
        showPhotoAlertController()
    }
    
    //MARK: - Methods
    
    func showPhotoAlertController() {
        
        let alertImage = UIAlertController(title: "Photo source", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.chooseImagePickerAction(source: .camera)
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.chooseImagePickerAction(source: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertImage.addAction(cameraAction)
        alertImage.addAction(photoAction)
        alertImage.addAction(cancelAction)
        
        present(alertImage, animated: true)
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            self.present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if coverPhotoButtonIsTapped {
            coverPhotoImageView.image = info[.editedImage] as? UIImage
            coverPhotoImageView.contentMode = .scaleAspectFill
            coverPhotoImageView.clipsToBounds = true
            coverPhotoImageView.isHidden = false
            coverPhotoButton.isHidden = true
            coverPhotoButtonIsTapped = false
            dismiss(animated: true, completion: nil)
        }
        if  firstPagePhotoButtonIsTapped {
            firstPagePhotoImageView.image = info[.editedImage] as? UIImage
            firstPagePhotoImageView.contentMode = .scaleAspectFill
            firstPagePhotoImageView.clipsToBounds = true
            firstPagePhotoImageView.isHidden = false
            firstPagePhotoButton.isHidden = true
            firstPagePhotoButtonIsTapped = false
            dismiss(animated: true, completion: nil)
        }
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
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "New element"
    }
    
    func showPickerView(pickerView: UIPickerView, pickerViewHeightConstraint: NSLayoutConstraint, pickerViewMarginTopConstraint: NSLayoutConstraint, show: Bool, animateTime: TimeInterval) {
        
        if pickerView == elementTypePicker {
            typePickerOpened = show
            UIView.animate(withDuration: animateTime, animations: {
                self.catalogueLabelMarginTop.constant = (show ? self.labelMarginTopOpened : self.labelMarginTopOpened-155)
                self.catalogueButtonMarginTop.constant = (show ? self.buttonMarginTopOpened : self.buttonMarginTopOpened-155)
                self.view.layoutIfNeeded()
            })
        }
        if pickerView == elementCataloguePicker {
            cataloguePickerOpened = show
        }
        
        pickerView.isHidden = !show
        UIView.animate(withDuration: animateTime, animations: {
            pickerViewHeightConstraint.constant = (show ? self.pickerHeightOpened : self.pickerHeightClosed)
            pickerViewMarginTopConstraint.constant = (show ? self.pickerMarginTopOpened : self.pickerMarginTopClosed)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func saveTapped() {
        saveButtonTapped(self)
    }
    
    @objc func backButtonTapped() {
        presenter.returnToElementView()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, don`t do anything
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

//MARK: - Extensions pickerView

extension NewElementViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case elementTypePicker:
            return ElementType.allCases.count
        case elementCataloguePicker:
            if let allCatalogues = presenter.allCatalogues {
                return allCatalogues.count
            }
        default:
            break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case elementTypePicker:
            return ElementType.allCases[row].rawValue
        case elementCataloguePicker:
            if let allCatalogues = presenter.allCatalogues {
                return allCatalogues[row].nameCatalogue
            }
        default:
            break
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case elementTypePicker:
            elementTypeButton.setTitle(ElementType.allCases[row].rawValue, for: .normal)
            elementType = ElementType.allCases[row].rawValue
            showPickerView(pickerView: elementTypePicker, pickerViewHeightConstraint: elementTypePickerHeight, pickerViewMarginTopConstraint: elementTypePickerMarginTop, show: !typePickerOpened, animateTime: animateTimeStd)
        case elementCataloguePicker:
            if let allCatalogues = presenter.allCatalogues {
                elementCatalogueButton.setTitle(allCatalogues[row].nameCatalogue, for: .normal)
                catalogue = allCatalogues[row]
                showPickerView(pickerView: elementCataloguePicker, pickerViewHeightConstraint: elementCataloguePickerHeight, pickerViewMarginTopConstraint: elementCataloguePickerMarginTop, show: !cataloguePickerOpened, animateTime: animateTimeStd)
            }
            
        default:
            break
        }
    }
    
    
}


//MARK: - View extension
extension NewElementViewController: NewElementViewProtocol {
    
    func success(successType: NewElementSuccessType, alert: UIAlertController?) {
        switch successType {
        case .saveOK:
            presenter.returnToElementView()
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!!!", message: error.localizedDescription), animated: true)
    }
    
    
}
