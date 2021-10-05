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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        registerTableViewCell()
        presenter.getCatalogues()
        configureNavigationBar()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        configureNavigationBar()
        presenter.getCatalogues()
    }
    
    func configureNavigationBar() {
        let currentVC = navigationController?.visibleViewController
        let numberOfCurrentVC = navigationController?.viewControllers.firstIndex(of: currentVC!)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        let addButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addTapped))
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.leftBarButtonItem = backButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.rightBarButtonItem = addButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "List of catalogues"
        
    }
    
    @objc func addTapped() {
        presenter.addTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    private func registerTableViewCell() {
        
        let customCell = UINib(nibName: "DataCustomTableViewCell", bundle: nil)
        self.tableView.register(customCell, forCellReuseIdentifier: "DataCustomCell")
        
    }
    
    
    
}

//MARK: - TableView configuration

extension DataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.catalogues?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DataCustomCell") as? DataCustomTableViewCell {
            let catalogue = presenter.catalogues?[indexPath.row]
            cell.catalogueNameLabel.text = catalogue?.nameCatalogue
            cell.catalogueTypeLabel.text = catalogue?.typeOfCatalogue
            cell.placeLabel.text = catalogue?.placeOfCatalogue
            if catalogue?.isFull == true {
                cell.isFullImage.isHidden = false
                cell.isNotFullImage.isHidden = true
            } else {
                cell.isFullImage.isHidden = true
                cell.isNotFullImage.isHidden = false
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDeleteItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, result) in
            //   guard let catalogueToDelete = self.presenter.catalogues?[indexPath.row] else { return }
            self.presenter.deleteCatalogue(indexPath: indexPath)
            self.presenter.catalogues?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            result(true)
        }
        actionDeleteItem.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [actionDeleteItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - View extension

extension DataViewController: DataPresenterViewProtocol {
    func success(successType: DataViewSuccessType, alert: UIAlertController?) {
        switch successType {
        case .loadDataOk:
            tableView.reloadData()
        case .contentTappOk:
            return
        case .emptyData:
            return
        case .deleteOk:
            return
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!!!", message: error.localizedDescription), animated: true)
    }
    
    
}
