//
//  Pokemon.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/29.
//

import Foundation

// MARK: - PokemonList
struct PokemonData: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [PokemonResult]
}

// MARK: - Result
struct PokemonResult: Codable {
    let name: String
    let url: String
}

// MARK: - Pokemon
struct Pokemon: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    let height: Int
    let weight: Int
    let types: [TypeElement]
}

// MARK: - Sprites
struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let type: Attribute
}

// MARK: - Species
struct Attribute: Codable {
    let name: String
    let url: String
}
