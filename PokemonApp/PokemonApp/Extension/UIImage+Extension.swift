//
//  UIImage+Extension.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/1.
//

import UIKit

enum SystemImageAsset: String {
    
    case house
    
    case houseFill = "house.fill"
    
    case star
    
    case starFill = "star.fill"
}

enum ImageAsset: String {
    
    case ball_placeholer
}

extension UIImage {

    static func systemAsset(_ asset: SystemImageAsset) -> UIImage? {

        return UIImage(systemName: asset.rawValue)
    }
    
    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
