//
//  BaseViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/2.
//

import UIKit

class BaseViewController: UIViewController {
    
    let favoriteViewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteViewModel.completeHandler = { [weak self] message in
            
            self?.showAlert(title: nil, message: message)
        }
        
        favoriteViewModel.errorHandler = { [weak self] error in
            
            self?.showAlertWithOK(title: "OOPs", message: "\(error)")
        }
    }
}
