//
//  ElementViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 23.09.2021.
//

import UIKit

class ElementViewController: UIViewController {
    
    //MARK: - Variables
    
    var presenter: ElementsPresenterInputProtocol!
    var alertManager: AlertControllerManagerProtocol!
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        registerTableViewCell()
        presenter.getElements()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        configureNavigationBar()
        presenter.getElements()
    }
    
    //MARK: - Methods
    
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
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "List of elements"
        
    }
    
    @objc func addTapped() {
        presenter.addElementTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.goToBack()
    }
    
    private func registerTableViewCell() {
        
        let customCell = UINib(nibName: "ElementCustomTableViewCell", bundle: nil)
        self.tableView.register(customCell, forCellReuseIdentifier: "elementCustomCell")
        
    }
    
    
    
}

extension ElementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.elements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "elementCustomCell") as? ElementCustomTableViewCell {
            let element = presenter.elements?[indexPath.row]
            cell.elementTitle.text = element?.title
            cell.elementType.text = element?.type
            cell.elementsCatalogue.text = element?.parentCatalogue
            cell.elementRealiseDate.text = element?.releaseDate
            
            if element?.type == ElementType.book.rawValue {
                cell.bookImage.isHidden = false
                cell.letterImage.isHidden = true
                cell.otherImage.isHidden = true
                
            }
            if element?.type == ElementType.letter.rawValue {
                cell.bookImage.isHidden = true
                cell.letterImage.isHidden = false
                cell.otherImage.isHidden = true
            }
            
            if element?.type == ElementType.otherElementType.rawValue {
                cell.bookImage.isHidden = true
                cell.letterImage.isHidden = true
                cell.otherImage.isHidden = false
            }
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let element = presenter.elements?[indexPath.row]
        presenter.tapOnElement(element: element)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDeleteItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, result) in
            
            self.presenter.deleteElement(element: indexPath.row)
            self.presenter.elements?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            result(true)
            
        }
        
        let actionToEdit = UIContextualAction(style: .normal, title: "Edit") {(contextualAction, view, result) in
            
            self.presenter.editElement()
            result(true)
            
        }
        
        actionToEdit.backgroundColor = .blue
        actionDeleteItem.backgroundColor = .red
        let swipeAction = UISwipeActionsConfiguration(actions: [actionToEdit, actionDeleteItem])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
        
    }
    
}

extension ElementViewController: ElementsPresenterViewProtocol {
    func success(successType: ElementSuccessType, alert: UIAlertController?) {
        switch successType {
        case .saveOk:
            return
        case .deleteOk:
            return
        case .emptyData:
            return
        case .elementTap:
            return
        case .loadOk:
            tableView.reloadData()
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!!!", message: error.localizedDescription), animated: true)
    }
    
    
}
