//
//  PokemonResultViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation

struct PokemonResultViewModel {
    
    private let pokemonResult: PokemonResult
    
    init(model pokemonResult: PokemonResult) {
        self.pokemonResult = pokemonResult
    }
    
    var name: String {
        pokemonResult.name
    }
    
    var url: String {
        pokemonResult.url
    }
    
    var id: String {
        
        guard let url = URL(string: pokemonResult.url) else { return "" }
        
        let id = url.lastPathComponent
        
        return id
    }
    
    var imageUrl: String {
        
        let urlString = PAConstant.imageBaseUrl.rawValue + "\(id)" + ".png"
        
        return urlString
    }
}
