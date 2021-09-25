//
//  ScanViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import UIKit

class NewCatalogueViewController: UIViewController {

    
    //MARK: - IBOutlet
    
    @IBOutlet weak var catalogueType: UIPickerView!
    @IBOutlet weak var catalogueName: UITextField!
    @IBOutlet weak var isFullSwitch: UISwitch!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Variables
    
    var presenter: NewCataloguePresenterProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: IBAction
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }



}

extension NewCatalogueViewController: NewCatalogueViewProtocol {
    func success(successType: NewCatSuccessType, alert: UIAlertController?) {
        
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
    }
    
    
}
