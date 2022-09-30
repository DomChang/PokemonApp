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

        setUp()
        style()
        layout()
    }
    
    private func setUp() {
        
        navigationItem.title = "Pokemon"
        
        tableView.register(PokemonListCell.self,
                           forCellReuseIdentifier: PokemonListCell.identifier)
        
        tableView.dataSource = self
        
        tableView.prefetchDataSource = self
        
        tableView.delegate = self
        
        viewModel.startRefreshHandler = { [weak self] in
            
            DispatchQueue.main.async {
                self?.refreshControl.beginRefreshing()
            }
        }
        
        viewModel.endRefreshHandler = { [weak self] in
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.indexPathToReload.bind { newIndexPathsToReload in
            
            guard !newIndexPathsToReload.isEmpty else {
                
                self.tableView.reloadData()
                
                return 
            }
            
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
        
        viewModel.fetchData()
        
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
        
        viewModel.fetchData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.identifier,
                                                       for: indexPath) as? PokemonListCell
        else {
            fatalError("Cannot dequeue PokemonListCell")
        }
        
        if isLoadingCell(for: indexPath) {
            
            cell.configureCell(with: .none)
            
        } else {
            
            let resultViewModel = viewModel.pokemonsViewModel[indexPath.row]
            
            cell.configureCell(with: resultViewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            
            viewModel.fetchData()
        }
    }
}

private extension HomeViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        
        indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        
        return Array(indexPathsIntersection)
    }
}
