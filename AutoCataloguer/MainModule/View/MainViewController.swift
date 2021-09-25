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
    
    //MARK: - Variables
    
    var presenter: MainModulePresenterInputProtocol!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanButton.layer.cornerRadius = scanButton.layer.bounds.height/2
        settingsButton.layer.cornerRadius = settingsButton.layer.bounds.height/2
        dataShowButton.layer.cornerRadius = dataShowButton.layer.bounds.height/2
        
        userNameLabel.text = presenter.setUserName()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        userNameLabel.text = presenter.setUserName()
        navigationController?.isNavigationBarHidden = true
        
    }


   

}
