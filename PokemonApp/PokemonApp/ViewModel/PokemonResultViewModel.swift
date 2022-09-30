//
//  PokemonResultViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation

class PokemonResultViewModel {
    
    let pokemonResult: PokemonResult
    
    init(model pokemonResult: PokemonResult) {
        self.pokemonResult = pokemonResult
    }
    
    var name: String {
        pokemonResult.name
    }
    
    var url: URL? {
        URL(string: pokemonResult.url)
    }
}
