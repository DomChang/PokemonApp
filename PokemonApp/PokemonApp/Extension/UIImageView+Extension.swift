//
//  UIImageView+Extension.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

extension UIImageView {

    func setImage(urlString: String?, placeholderImage: UIImage?) {
        
        if placeholderImage != nil {
            
            self.image = placeholderImage
        }
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            
            self.image = placeholderImage
            return
        }
        
        HTTPClient.shared.fetchImage(url: url) { image in
            
            DispatchQueue.main.async {
                
                self.image = image ?? placeholderImage
            }
        }
    }
}
