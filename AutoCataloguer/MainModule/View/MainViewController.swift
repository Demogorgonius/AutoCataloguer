//
//  MainViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 02.09.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var dataShowButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var elementListButton: UIButton!
    
    
    //MARK: - Variables
    
    var presenter: MainModulePresenterInputProtocol!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanButton.layer.cornerRadius = scanButton.layer.bounds.height/2
        settingsButton.layer.cornerRadius = settingsButton.layer.bounds.height/2
        dataShowButton.layer.cornerRadius = dataShowButton.layer.bounds.height/2
        elementListButton.layer.cornerRadius = elementListButton.layer.bounds.height/2
        
        userNameLabel.text = presenter.setUserName()
        
    }
    
    
    //MARK: - @IBAction
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        presenter.newCatalogueTapped()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        presenter.settingsButtonTapped()
    }
    
    @IBAction func dataShowButtonTapped(_ sender: Any) {
        presenter.showDataButtonTapped()
    }
    
    @IBAction func listElementsButtonTapped(_ sender: Any) {
        
        presenter.elementListButtonTapped()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        userNameLabel.text = presenter.setUserName()
        navigationController?.isNavigationBarHidden = true
        
    }


   

}
