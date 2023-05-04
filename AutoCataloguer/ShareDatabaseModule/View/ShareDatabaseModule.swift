//
//  ShareDatabaseModule.swift
//  AutoCataloguer
//
//  Created by Sergey on 29.11.2022.
//

import Foundation
import UIKit
import SnapKit
import CloudKit
import SharedWithYou

class ShareDataBaseViewController: UIViewController {
    var presenter: ShareDataBaseModuleProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    lazy var exportButton: UIButton = {
        let button = UIButton(frame: ButtonProperty().buttonFrame)
        button.setTitle("Export Data", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.black)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.layer.bounds.height/2
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var importButton: UIButton = {
        let button = UIButton(frame: ButtonProperty().buttonFrame)
        button.setTitle("Import Data", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .black)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.layer.bounds.height/2
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(frame: ButtonProperty().buttonFrame)
        button.setTitle("Share Data", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .black)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.layer.bounds.height/2
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 23.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.exportButton,
         self.importButton,
         self.shareButton].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureNavigationBar()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(190)
            make.leading.equalToSuperview().offset(70)
        }
        
        
        
        
    }
    
    
    @objc func exportButtonTapped(sender: UIButton! ) {
        presenter.exportDataBaseToGoogleTap()
    }
    
    @objc func importButtonTapped(sender: UIButton!) {
        presenter.importDataBaseFromGoogleTap()
    }
    
    @objc func shareButtonTapped(sender: UIButton!) {
        presenter.shareDatabaseTap()
    }
    
    @objc func backButtonTapped() {
        presenter.goToBackTapped()
    }
    
    func configureNavigationBar() {
        
        let currentVC = navigationController?.visibleViewController
        let numberOfCurrentVC = navigationController?.viewControllers.firstIndex(of: currentVC!)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.leftBarButtonItem = backButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "Sharing database"
    }
    
}

extension ShareDataBaseViewController: ShareDataBaseViewProtocol {
    func success(type: ShareSuccessType) {
        switch type {
        case .shareSuccess:
            showShareView()
        case .importSuccess:
            return
        case .exportSuccess:
            return
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Ошибка!" , message: error.localizedDescription), animated: true)
    }
    
    
}

extension ShareDataBaseViewController {
    func showShareView() {
        
    }
}
