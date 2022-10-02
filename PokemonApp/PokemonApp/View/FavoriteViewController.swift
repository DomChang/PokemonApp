//
//  FavoriteViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/1.
//

import UIKit

class FavoriteViewController: BaseViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteViewModel.fetchFavorite {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func setup() {
        navigationItem.title = "Favorite"
        
        tableView.register(PokemonListCell.self,
                           forCellReuseIdentifier: PokemonListCell.identifier)
        
        tableView.dataSource = self
        
        tableView.delegate = self
    }
    
    private func style() {
        
        view.backgroundColor = .white
    }
    
    private func layout() {
        
        view.addSubview(tableView)
        
        tableView.fillSafeLayout()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        favoriteViewModel.favoritePokemonViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier,
                                                       for: indexPath) as? PokemonListCell
        else {
            fatalError("Cannot dequeue PokemonListCell")
        }
        
        let resultViewModel = favoriteViewModel.favoritePokemonViewModels[indexPath.row]
        
        cell.configureCell(with: resultViewModel, isStar: true)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pokemonViewModel = favoriteViewModel.favoritePokemonViewModels[indexPath.row]
        
        let detailVC = DetailViewController(pokemonResultViewModel: pokemonViewModel)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension FavoriteViewController: PokemonListCellDelegate {
    
    func didTapStar(with cell: PokemonListCell, isStar: Bool) {
        
        guard let indexPath = tableView.indexPath(for: cell),
              let id = cell.pokemonResultViewModel?.id else { return }
        
        favoriteViewModel.removePokemon(id: id)
        
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
