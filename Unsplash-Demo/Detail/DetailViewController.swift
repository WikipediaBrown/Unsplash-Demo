//
//  DetailViewController.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol DetailPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func onDismiss()
}

final class DetailViewController: UIViewController, DetailPresentable, DetailViewControllable {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    weak var listener: DetailPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.onDismiss()
    }
    
    func setImage(image: Image) {
        
    }
        
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
