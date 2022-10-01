//
//  UIColor+Extension.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/2.
//

import Foundation
import UIKit

extension UIColor {
 
    static func paColor(name: String) -> UIColor {
        
        return UIColor(named: name) ?? .white
    }
}
