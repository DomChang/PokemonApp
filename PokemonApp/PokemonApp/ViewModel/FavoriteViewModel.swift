//
//  FavoriteViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/1.
//

import Foundation

class FavoriteViewModel {

    var favoritePokemonViewModels = [PokemonResultViewModel]()
    
    var completeHandler: ((String) -> Void)?
    
    var errorHandler: ((Error) -> Void)?
    
    private var lsPokemons = [LSPokemon]()
    
    func fetchFavorite(completion: (() -> Void)?) {
        
        StorageManager.shared.fetchPokemons { result in
            
            switch result {
                
            case .success(let lsPokemons):
                
                favoritePokemonViewModels = self.covertLSToPokemons(from: lsPokemons)
                
                self.lsPokemons = lsPokemons
                
                completion?()
                
            case .failure(let error):
                
                print("fetchLSData.failure: \(error)")
            }
        }
    }
    
    func savePokemon(with pokemonResultViewModel: PokemonResultViewModel) {
        
        fetchFavorite {
            
            guard !self.lsPokemons.contains(where: { $0.id == pokemonResultViewModel.id }) else { return }
            
            StorageManager.shared.savePokemonInFavorite(with: pokemonResultViewModel) { result in
                
                switch result {
                    
                case .success:
                    
                    self.completeHandler?("Save Success")
                    
                    self.favoritePokemonViewModels.append(pokemonResultViewModel)
                    
                case .failure(let error):
                    
                    self.errorHandler?(error)
                }
            }
        }
    }
    
    func removePokemon(id: String) {
        
        fetchFavorite {
            
            guard let lsPokemon = self.lsPokemons.filter({ $0.id == id }).first else { return }
            
            StorageManager.shared.removePokemonfromFavorite(lsPokemon: lsPokemon) { result in
                
                switch result {
                    
                case .success:
                    
                    self.favoritePokemonViewModels = self.favoritePokemonViewModels.filter { $0.id != id }
                    
                    self.completeHandler?("Remove Success")
                    
                case .failure(let error):
                    
                    self.errorHandler?(error)
                }
            }
        }
    }
    
    func checkIsStar(id: String) -> Bool {
        
        favoritePokemonViewModels.contains(where: { $0.id == id })
    }
    
    func deleteAll() {
        
        StorageManager.shared.deleteAll()
    }
    
    private func covertLSToPokemons(from lsPokemons: [LSPokemon]) -> [PokemonResultViewModel] {
        
        var pokemonResultViewModels = [PokemonResultViewModel]()
        
        for lsPokemon in lsPokemons {
            
            guard let name = lsPokemon.name,
                  let url = lsPokemon.detailURL else { continue }
            
            let pokemonResult = PokemonResult(name: name,
                                              url: url)
            
            let pokemonResultViewModel = PokemonResultViewModel(model: pokemonResult)
            
            pokemonResultViewModels.append(pokemonResultViewModel)
        }
        return pokemonResultViewModels
    }
}
