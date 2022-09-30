//
//  HomeViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation

class HomeViewModel {
    
    let pokemonsViewModel = Box([PokemonResultViewModel]())
    
    var startRefreshHandler: (() -> Void)?
    
    var endRefreshHandler: (() -> Void)?
    
    private let pokemonProvider = PokemonProvider()
    
    func fetchData(paging: Int?) {
        
        startRefreshHandler?()
        
        pokemonProvider.fetchPokemonList(paging: paging) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let pokemonResults):
                
                self.pokemonsViewModel.value = pokemonResults.map {
                    
                    PokemonResultViewModel(model: $0)
                }
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
            self.endRefreshHandler?()
        }
    }
}
