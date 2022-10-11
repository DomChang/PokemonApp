//
//  CacheImageView.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/11.
//

import UIKit

class CacheImageView: UIImageView {
    
    private let imageCache = NSCache<NSURL, UIImage>()
    
    private var imageUrlString: String?
    
    func loadImage(urlString: String?) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            
            self.image = nil
            
            return
        }
        
        self.imageUrlString = urlString
        
        if let image = imageCache.object(forKey: url as NSURL) {
            
            self.image = image
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil, let data = data else {
                
                print(error!)
                
                return
            }
            
            
            if let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    
                    if self.imageUrlString == urlString {
                        
                        self.image = image
                    }
                }
                self.imageCache.setObject(image, forKey: url as NSURL)
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.image = .asset(.ball_placeholer)
                }
            }
        }.resume()
    }
}
