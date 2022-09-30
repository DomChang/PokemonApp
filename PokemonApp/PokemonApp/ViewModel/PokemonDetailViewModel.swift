//
//  PokemonDetailViewModel.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import Foundation
import UIKit

struct PokemonDetailViewModel {
    
    private let pokemon: Pokemon
    
    init(model pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var id: String {
        "\(pokemon.id)"
    }
    
    var imageUrl: String {
        pokemon.sprites.frontDefault
    }
    
    var height: String {
        "\(pokemon.height)"
    }
    
    var weight: String {
        "\(pokemon.weight)"
    }
    
    var type: [String] {
        pokemon.types.map {
            $0.type.name
        }
    }
}
