//
//  FavoriteViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/10/1.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let viewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFavorite {
            
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
        
        viewModel.favoritePokemonViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier,
                                                       for: indexPath) as? PokemonListCell
        else {
            fatalError("Cannot dequeue PokemonListCell")
        }
        
        let resultViewModel = viewModel.favoritePokemonViewModels[indexPath.row]
        
        cell.configureCell(with: resultViewModel, isStar: true)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pokemonViewModel = viewModel.favoritePokemonViewModels[indexPath.row]
        
        let detailVC = DetailViewController(pokemonResultViewModel: pokemonViewModel,
                                            storageViewModel: viewModel)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoriteViewController: PokemonListCellDelegate {
    
    func didTapStar(with cell: PokemonListCell, isStar: Bool) {
        
        guard let indexPath = tableView.indexPath(for: cell),
              let id = cell.pokemonResultViewModel?.id else { return }
        
        viewModel.removePokemon(id: id)
        
        viewModel.favoritePokemonViewModels.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
