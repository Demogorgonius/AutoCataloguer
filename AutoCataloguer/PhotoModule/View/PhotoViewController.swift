//
//  PhotoViewController.swift
//  AutoCataloguer
//
//  Created by Sergey on 19.01.2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: - Variables
    
    var presenter: PhotoModuleProtocol!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var elementNameLabel: UILabel!
    @IBOutlet weak var elementPhotoTypeLabel: UILabel!
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setPhoto()
        photoImageView.enableZoom()
        photoImageView.enablePanning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    //MARK: - Methods
    func configureNavigationBar() {
        let currentVC = navigationController?.visibleViewController
        let numberOfCurrentVC = navigationController?.viewControllers.firstIndex(of: currentVC!)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.leftBarButtonItem = backButton
        navigationController?.viewControllers[numberOfCurrentVC ?? 1].navigationItem.title = "Photo viewer"
    }
    
    @objc func backButtonTapped() {
        presenter.goToBack()
    }
    
}

//MARK: - Extensions

extension PhotoViewController: PhotoModuleViewProtocol {
    
    func setPhoto(element: Element?, elementPhotoType: ElementPhotoType?) {
        if let element = element {
            elementNameLabel.text = element.title
            
            if let type = elementPhotoType {
                
                switch type {
                case .cover:
                    
                    elementPhotoTypeLabel.text = "Cover"
                    if let image = element.coverImage {
                        photoImageView.image = UIImage(data: image)
                    }
                    
                case .firstPage:
                    
                    elementPhotoTypeLabel.text = "First page"
                    if let image = element.pageImage {
                        photoImageView.image = UIImage(data: image)
                    }
                    
                }
                
            } else {
                elementPhotoTypeLabel.text = "Unknown type"
            }
            
        } else {
            elementNameLabel.text = "Nothing to show"
        }
    }
    
}

extension UIImageView {
    func enableZoom() {
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
        
    }
    
    func enablePanning() {
        
        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(startPanning(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(scrollGesture)
        
    }
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    @objc private func startPanning(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                    y:view.center.y + translation.y)
          }
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    
}
