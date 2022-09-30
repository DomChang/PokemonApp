//
//  DetailViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation

class DetailViewModel {
    
    var pokemonViewModel: Box<PokemonDetailViewModel?> = Box(nil)
    
    var pokemonUrl: String
    
    init(pokemonUrl: String) {
        
        self.pokemonUrl = pokemonUrl
    }
    
    private let pokemonProvider = PokemonProvider()
    
    func fetchDetail() {
        
        pokemonProvider.fetchDetail(url: pokemonUrl) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let pokemon):
                
                self.pokemonViewModel.value = PokemonDetailViewModel(model: pokemon)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
}
