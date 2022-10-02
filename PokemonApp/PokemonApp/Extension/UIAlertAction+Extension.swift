//
//  UIAlertAction+Extension.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/2.
//

import UIKit

extension UIAlertAction {
    
    static var okAction: UIAlertAction {
        
        return UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
}
