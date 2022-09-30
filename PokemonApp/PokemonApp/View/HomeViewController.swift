//
//  HomeViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }
    
    private func setup() {
        
        navigationItem.title = "Pokemon"
        
        tableView.register(PokemonListCell.self,
                           forCellReuseIdentifier: PokemonListCell.identifier)
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        viewModel.pokemonsViewModel.bind { _ in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.startRefreshHandler = { [weak self] in
            
            self?.refreshControl.beginRefreshing()
            
        }
        
        viewModel.endRefreshHandler = { [weak self] in
            
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.fetchData(paging: nil)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func style() {
        
        view.backgroundColor = .white
        
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    private func layout() {
        
        view.addSubview(tableView)
        
        tableView.fillSafeLayout()
        
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshData() {
        
        viewModel.fetchData(paging: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pokemonsViewModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier,
                                                       for: indexPath) as? PokemonListCell
        else {
            fatalError("Cannot dequeue PokemonListCell")
        }
        
        let resultViewModel = viewModel.pokemonsViewModel.value[indexPath.row]
        
        cell.configureCell(with: resultViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pokemonViewModel = viewModel.pokemonsViewModel.value[indexPath.row]
        
        let detailVC = DetailViewController(pokemonName: pokemonViewModel.name,
                                            pokemonUrl: pokemonViewModel.url)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
