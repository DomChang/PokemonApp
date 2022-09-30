//
//  UIImageView+Extension.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

extension UIImageView {

    func setImage(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        HTTPClient.shared.fetchImage(url: url) { image in
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
