//
//  UIViewController+Extension.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/2.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?,
                   message: String?) {
        
        let alertController = UIAlertController(title: title,
                                               message: message,
                                               preferredStyle: .alert)
        
        self.present(alertController, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showAlertWithOK(title: String?,
                   message: String?) {
        
        let alerContorller = UIAlertController(title: title,
                                               message: message,
                                               preferredStyle: .alert)
        
        alerContorller.addAction(.okAction)
        
        self.present(alerContorller, animated: true)
    }
}
