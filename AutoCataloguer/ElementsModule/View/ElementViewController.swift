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
    var searchController: UISearchController!
    var filteredResultArray: [Element] = []
    private var searchBarIsEmpty: Bool {
        guard let inputText = searchController.searchBar.text else { return false }
        return inputText.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Title"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        registerTableViewCell()
        //        presenter.getElements(display: .existing)
        //        configureNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        configureNavigationBar()
        presenter.getElements(display: .existing)
    }
    
    //MARK: IBAction
    
    @IBAction func existingButtonTapped(_ sender: Any) {
        presenter.getElements(display: .existing)
    }
    
    @IBAction func deletedButtonTapped(_ sender: Any) {
        presenter.getElements(display: .deleted)
    }
    
    @IBAction func noCatalogueButtonTapped(_ sender: Any) {
        presenter.getElements(display: .noCatalogue)
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


//MARK: - TableView extensions

extension ElementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering{
            return filteredResultArray.count
        } else {
            return presenter.elements?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "elementCustomCell") as? ElementCustomTableViewCell {
        
            let element = isFiltering ? filteredResultArray[indexPath.row] : presenter.elements?[indexPath.row]
            
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
        
//        let element = presenter.elements?[indexPath.row]
        let element = isFiltering ? filteredResultArray[indexPath.row] : presenter.elements?[indexPath.row]
        presenter.tapOnElement(element: element)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDeleteItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, result) in
            
            self.presenter.deleteElement(elementIndex: indexPath)
            //            self.presenter.elements?.remove(at: indexPath.row)
            //            tableView.deleteRows(at: [indexPath], with: .fade)
            result(true)
            
        }
        
        let actionToEdit = UIContextualAction(style: .normal, title: "Edit") {(contextualAction, view, result) in
            self.presenter.setElements()
            let element = self.presenter.elements?[indexPath.row]
            self.presenter.editElement(element: element)
            result(true)
            
        }
        
        actionToEdit.backgroundColor = .blue
        actionDeleteItem.backgroundColor = .red
        let swipeAction = UISwipeActionsConfiguration(actions: [actionToEdit, actionDeleteItem])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
        
    }
    
}

//MARK: - Search controller extension

extension ElementViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterElementsForSearchText(searchController.searchBar.text!)
    }
    
    private func filterElementsForSearchText (_ searchText: String) {
        guard let elements = presenter.elements else { return }
        filteredResultArray = elements.filter({ (element: Element) -> Bool in
            if let title = element.title {
                return title.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        })
        
        tableView.reloadData()
    }
    
}


//MARK: - View protocol extension

extension ElementViewController: ElementsPresenterViewProtocol {
    func success(successType: ElementSuccessType, alert: UIAlertController?, index: IndexPath?) {
        switch successType {
        case .saveOk:
            return
        case .deleteOk:
            tableView.deleteRows(at: [index!], with: .fade)
            tableView.reloadData()
            return
        case .emptyData:
            tableView.reloadData()
        case .elementTap:
            return
        case .loadOk:
            tableView.reloadData()
        case .showAlert:
            guard let alert = alert else { return}
            present(alert, animated: true)
        }
    }
    
    func failure(error: Error) {
        present(alertManager.showAlert(title: "Error!!!", message: error.localizedDescription), animated: true)
    }
    
}
