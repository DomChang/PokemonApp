//
//  HomeViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let refreshControl = UIRefreshControl()
    
    private let viewModel = HomeViewModel()
    
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
        
        navigationItem.title = "Pokemon"
        
        tableView.register(PokemonListCell.self,
                           forCellReuseIdentifier: PokemonListCell.identifier)
        
        tableView.dataSource = self
        
        tableView.prefetchDataSource = self
        
        tableView.delegate = self
        
        viewModel.endRefreshHandler = {
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
        viewModel.fetchErrorHandler = { [weak self] error in
            
            self?.showAlertWithOK(title: "OOPs", message: "\(error)")
        }
        
        viewModel.pokemonViewModels.bind { _ in
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        
        viewModel.fetchData()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func style() {
        
        tableView.backgroundColor = .lightGray.withAlphaComponent(0.6)
        
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    private func layout() {
        
        view.addSubview(tableView)
        
        tableView.fillSafeLayout()
        
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshData() {
        
        viewModel.currentPage = 0
        
        viewModel.fetchData()
        
        favoriteViewModel.fetchFavorite(completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        viewModel.totalCount > viewModel.currentCount ?
        viewModel.currentCount + 19 : viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier,
                                                       for: indexPath) as? PokemonListCell
        else {
            fatalError("Cannot dequeue PokemonListCell")
        }
        
        if isLoadingCell(for: indexPath) {
            
            cell.configureCell(with: nil, isStar: false)
            
            cell.isUserInteractionEnabled = false
            
        } else {
            
            let resultViewModel = viewModel.pokemonViewModels.value[indexPath.row]
            
            cell.configureCell(with: resultViewModel,
                               isStar: favoriteViewModel.checkIsStar(id: resultViewModel.id))
            
            cell.delegate = self
            
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pokemonViewModel = viewModel.pokemonViewModels.value[indexPath.row]
        
        let detailVC = DetailViewController(pokemonResultViewModel: pokemonViewModel)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            
            viewModel.fetchData()

        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {

        indexPath.row >= viewModel.currentCount
    }
}

extension HomeViewController: PokemonListCellDelegate {
    
    func didTapStar(with cell: PokemonListCell, isStar: Bool) {
        
        guard let pokemonResultViewModel = cell.pokemonResultViewModel else {
            return
        }
        
        if isStar {
            
            favoriteViewModel.savePokemon(with: pokemonResultViewModel)
        } else {
            
            favoriteViewModel.removePokemon(id: pokemonResultViewModel.id)
        }
    }
}
