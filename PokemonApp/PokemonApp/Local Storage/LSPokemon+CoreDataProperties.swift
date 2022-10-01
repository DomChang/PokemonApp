//
//  LSPokemon+CoreDataProperties.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/1.
//
//

import Foundation
import CoreData


extension LSPokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LSPokemon> {
        return NSFetchRequest<LSPokemon>(entityName: "LSPokemon")
    }

    @NSManaged public var detailURL: String?
    @NSManaged public var name: String?
    @NSManaged public var id: String?

}

extension LSPokemon : Identifiable {

}
