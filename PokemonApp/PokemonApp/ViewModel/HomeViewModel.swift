//
//  HomeViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation

class HomeViewModel {
    
    var pokemonViewModels = Box([PokemonResultViewModel]())
    
    var startRefreshHandler: (() -> Void)?
    
    var endRefreshHandler: (() -> Void)?
    
    var totalCount = 0
    
    var currentPage = 0
    
    var fetchErrorHandler: ((Error) -> Void)?
    
    private let pokemonProvider = PokemonProvider()
    
    private var isFetching = false
    
    var currentCount: Int {
        
        pokemonViewModels.value.count
    }
    
    func fetchData() {
        
        guard !isFetching else { return }
        
        isFetching = true
        
        pokemonProvider.fetchPokemonList(paging: currentPage) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let pokemonData):
                
                let pokemonResults = pokemonData.results
                
                self.totalCount = pokemonData.count
                
                if self.currentPage > 0 {
                    
                    self.pokemonViewModels.value.append(contentsOf: pokemonResults.map {
                        
                        PokemonResultViewModel(model: $0)
                    })
                    
                } else {
                    
                    self.pokemonViewModels.value = pokemonResults.map {
                        
                        PokemonResultViewModel(model: $0)
                    }
                }
                
                self.currentPage += 1
                
            case .failure(let error):
                
                self.fetchErrorHandler?(error)
            }
            
            self.isFetching = false
            
            self.endRefreshHandler?()
        }
    }
}
