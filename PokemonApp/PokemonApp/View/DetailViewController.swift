//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class DetailViewController: UIViewController {
    
    let pokemonName: String
    
    let pokemonUrl: String
    
    private lazy var viewModel = DetailViewModel(pokemonUrl: pokemonUrl)
    
    private let idTitleLabel = UILabel()
    
    private let idLabel = UILabel()
    
    private let imageView = UIImageView()
    
    private let heightTitleLabel = UILabel()
    
    private let heightLabel = UILabel()
    
    private let weightTitleLabel = UILabel()
    
    private let weightLabel = UILabel()
    
    private let typeTitleLabel = UILabel()
    
    private let typeLabel = UILabel()
    
    init(pokemonName: String, pokemonUrl: String) {
        self.pokemonName = pokemonName
        self.pokemonUrl = pokemonUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }
    
    private func setup() {
        
        navigationItem.title = "\(pokemonName)"
        
        view.backgroundColor = .white
        
        viewModel.pokemonViewModel.bind { [weak self] pokemonDetailViewModel in
            
            guard let self = self else { return }
            
            self.idLabel.text = pokemonDetailViewModel?.id
            
            self.heightLabel.text = pokemonDetailViewModel?.height
            
            self.weightLabel.text = pokemonDetailViewModel?.weight
            
            self.typeLabel.text = pokemonDetailViewModel?.type.joined(separator: ", ")
            
            guard let imageUrl = pokemonDetailViewModel?.imageUrl else { return }
            
            self.imageView.setImage(urlString: imageUrl)
        }
        
        viewModel.fetchDetail()
    }
    
    private func style() {
        
        idTitleLabel.text = "ID"
        idTitleLabel.font = .systemFont(ofSize: 16)
        
        idLabel.font = .systemFont(ofSize: 16)
        
        heightTitleLabel.text = "HEIGHT"
        heightTitleLabel.font = .systemFont(ofSize: 16)
        
        heightLabel.font = .systemFont(ofSize: 16)
        
        weightTitleLabel.text = "WEIGHT"
        weightTitleLabel.font = .systemFont(ofSize: 16)
        
        weightLabel.font = .systemFont(ofSize: 16)
        
        typeTitleLabel.text = "TYPE"
        typeTitleLabel.font = .systemFont(ofSize: 16)
        
        typeLabel.font = .systemFont(ofSize: 16)
    }
    
    private func layout() {
        
        let idHStack = UIStackView(arrangedSubviews: [idTitleLabel, idLabel])
        idHStack.axis = .horizontal
        idHStack.spacing = 10
        idTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let heightHStack = UIStackView(arrangedSubviews: [heightTitleLabel, heightLabel])
        heightHStack.axis = .horizontal
        heightHStack.spacing = 10
        heightTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let weightHStack = UIStackView(arrangedSubviews: [weightTitleLabel, weightLabel])
        weightHStack.axis = .horizontal
        weightHStack.spacing = 10
        weightTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let typeHStack = UIStackView(arrangedSubviews: [typeTitleLabel, typeLabel])
        typeHStack.axis = .horizontal
        typeHStack.spacing = 10
        typeTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let VStack = UIStackView(arrangedSubviews: [idHStack, heightHStack, weightHStack, typeHStack])
        VStack.axis = .vertical
        VStack.distribution = .fillEqually
        
        view.addSubview(imageView)
        view.addSubview(VStack)
        
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         width: 100,
                         height: 100,
                         padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0))
        
        VStack.anchor(top: imageView.bottomAnchor,
                      leading: imageView.leadingAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      trailing: view.trailingAnchor,
                      padding: UIEdgeInsets(top: 16, left: 0, bottom: 50, right: 20))
    }
}
