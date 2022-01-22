//
//  ElementDetailViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import UIKit

class ElementDetailViewController: UIViewController {
    
    //MARK: - Variables
    
    var presenter: ElementDetailPresenterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    let imagePreviewSize = CGSize(width: 100, height: 100)
    
    //MARK: - IBOutlets

    @IBOutlet weak var elementNameLabel: UILabel!
    @IBOutlet weak var elementTypeLabel: UILabel!
    @IBOutlet weak var elementDescriptionLabel: UITextView!
    @IBOutlet weak var elementAuthorLabel: UILabel!
    @IBOutlet weak var elementParentCatalogueLabel: UILabel!
    @IBOutlet weak var elementRealiseDateLabel: UILabel!
    @IBOutlet weak var elementCoverImageButton: UIButton!
    @IBOutlet weak var elementFirstPageImageButton: UIButton!

        
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ElementDetailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ElementDetailViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        presenter.setElement()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        configureNavigationBar()
        
    }
    
    //MARK: - IBActions
    
    @IBAction func coverPhotoTapped(_ sender: Any) {
        
    }
    
    @IBAction func firstPagePhotoTapped(_ sender: Any) {
        
    }

    //MARK: - Methods
    
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
    
    func configureNavigationBar() {
        let currentVC = navigationController?.visibleViewController
        let numberOfCurrentVC = navigationController?.viewControllers.firstIndex(of: currentVC!)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil.circle.fill"), style: .plain, target: self, action: #selector(editTapped))
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.leftBarButtonItem = backButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.rightBarButtonItem = editButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "Element detail"
    }
    
    @objc func editTapped() {
        presenter.editButtonTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.goToBack()
    }

}

extension ElementDetailViewController: ElementDetailViewProtocol {
    
    func setElement(element: Element?) {
        
        elementNameLabel.text = element?.title
        elementTypeLabel.text = element?.type
        elementDescriptionLabel.text = element?.elementDescription
        elementAuthorLabel.text = element?.author
        elementParentCatalogueLabel.text = element?.parentCatalogue
        elementRealiseDateLabel.text = element?.releaseDate
        
        if let coverImage = element?.coverImage {
            let image = UIImage(data: coverImage)?.resizeImageTo(size: imagePreviewSize)
            elementCoverImageButton.setImage(image, for: .normal)
            elementCoverImageButton.setTitle("", for: .normal)
        } else {
            elementCoverImageButton.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
            elementCoverImageButton.setTitle("", for: .normal)
        }
        
        if let firstPageImage = element?.pageImage {
            let image = UIImage(data: firstPageImage)?.resizeImageTo(size: imagePreviewSize)
            elementFirstPageImageButton.setImage(image, for: .normal)
            elementFirstPageImageButton.setTitle("", for: .normal)
        } else {
            elementFirstPageImageButton.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
            elementFirstPageImageButton.setTitle("", for: .normal)
        }
        
    }

}

extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

