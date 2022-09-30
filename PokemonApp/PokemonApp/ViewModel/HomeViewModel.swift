//
//  HomeViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation

class HomeViewModel {
    
    var pokemonsViewModel = [PokemonResultViewModel]()
    
    let indexPathToReload = Box([IndexPath]())
    
    var startRefreshHandler: (() -> Void)?
    
    var endRefreshHandler: (() -> Void)?
    
    var totalCount = 0
    
    var fetchCompletedHandler: (([IndexPath]) -> Void)?
    
    private let pokemonProvider = PokemonProvider()
    
    private var currentPage = 0
    
    private var isFetching = false
    
    var currentCount: Int {
        
        pokemonsViewModel.count
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
                
                self.pokemonsViewModel.append(contentsOf: pokemonResults.map {
                    
                    PokemonResultViewModel(model: $0)
                })
                
                if self.currentPage > 0 {
                    
                    self.indexPathToReload.value = self.calculateIndexPathsToReload(from: pokemonResults)
                    
                } else {
                    
                    self.indexPathToReload.value = []
                }
                
                self.currentPage += 1
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
            self.isFetching = false
            
            self.endRefreshHandler?()
        }
    }
    
    private func calculateIndexPathsToReload(from newPokemonResults: [PokemonResult]) -> [IndexPath] {
        
        let startIndex = pokemonsViewModel.count - newPokemonResults.count
        
        let endIndex = startIndex + newPokemonResults.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
