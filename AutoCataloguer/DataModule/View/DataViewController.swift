//
//  DataViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 03.09.2021.
//

import UIKit

class DataViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var presenter: DataPresenterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        let addButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addTapped))
        navigationController?.viewControllers[1].navigationItem.rightBarButtonItem = addButton
        navigationController?.viewControllers[1].navigationItem.title = "List of catalogues"
        
    }
    
    @objc func addTapped() {
        
    }

}

extension DataViewController: DataPresenterViewProtocol {
    func success(successType: DataViewSuccessType, alert: UIAlertController?) {
        
    }
    
    func failure(error: Error) {
        
    }
    
    
}
