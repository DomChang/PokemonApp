//
//  StorageManager.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/1.
//

import CoreData

enum LocalStorageError: Error {
    
    case fetchLocalStorageError
    
    case updateLocalStorageError
}

class StorageManager {
    
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private init() {
        
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PokemonApp")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            
            if
                let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Methods
    
    func saveContext(completion: (Result<Void, Error>) -> Void) {
        
        let context = StorageManager.shared.persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                
                try context.save()
                
                NotificationCenter.default.post(name: .didChangeFavorite, object: nil)

                completion(.success(()))
                
            } catch {
                
                completion(.failure(LocalStorageError.updateLocalStorageError))
            }
        }
    }

    func fetchPokemons(completion: ((Result<[LSPokemon], Error>) -> Void)) {

        let request: NSFetchRequest<LSPokemon> = LSPokemon.fetchRequest()

        do {

            let pokemons = try StorageManager.shared.persistentContainer.viewContext.fetch(request)

            completion(.success(pokemons))

        } catch {

            completion(.failure(LocalStorageError.fetchLocalStorageError))
        }
    }

    func savePokemonInFavorite(with pokemonResultViewModel: PokemonResultViewModel, completion: (Result<Void, Error>) -> Void) {

        let context = StorageManager.shared.persistentContainer.viewContext

        let lsPokemon = LSPokemon(entity: LSPokemon.entity(), insertInto: context)

        let pokemon = pokemonResultViewModel
        
        lsPokemon.id = pokemon.id
        
        lsPokemon.detailURL = pokemon.url
        
        lsPokemon.name = pokemon.name
        
        saveContext { result in

            switch result {

            case .success:

                completion(.success(()))

            case .failure(let error):

                completion(.failure(error))
            }
        }
    }

    func removePokemonfromFavorite(lsPokemon: LSPokemon, completion: (Result<Void, Error>) -> Void) {

        let context = StorageManager.shared.persistentContainer.viewContext

        context.delete(lsPokemon)

        saveContext { result in

            switch result {

            case .success:

                completion(.success(()))

            case .failure(let error):

                completion(.failure(error))
            }
        }
    }
    
    func deleteAll() {
       
        let context = StorageManager.shared.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "LSPokemon")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            
            try context.save()

        } catch {
            print ("There is an error in deleting LSPokemons")
        }
    }
}
