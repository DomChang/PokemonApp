//
//  PokemonProvider.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/29.
//

import Foundation

class PokemonProvider {
    
    typealias PokemonDataHandler = (Result<[PokemonResult], Error>) -> Void
    
    let decoder = JSONDecoder()
    
    func fetchPokemonList(paging: Int?, completion: @escaping PokemonDataHandler) {
        
        HTTPClient.shared.requestData(baseUrl: PAConstant.pokemonBaseUrl.rawValue,
                                      paging: paging) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    let pokemonData = try self.decoder.decode(PokemonData.self, from: data)
                    
                    let pokemonResult = pokemonData.results
                    
                    DispatchQueue.main.async {
                        completion(.success(pokemonResult))
                    }
                } catch {
                    
                    completion(.failure(HTTPError.decodeDataFail))
                }
                
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
}
