//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class DetailViewController: UIViewController {
    
    private lazy var viewModel = DetailViewModel(pokemonUrl: pokemonResultViewModel.url)
    
    private let idTitleLabel = UILabel()
    
    private let idLabel = UILabel()
    
    private let imageView = UIImageView()
    
    private let heightTitleLabel = UILabel()
    
    private let heightLabel = UILabel()
    
    private let weightTitleLabel = UILabel()
    
    private let weightLabel = UILabel()
    
    private let typeTitleLabel = UILabel()
    
    private let typeLabel = UILabel()
    
    private let starButton = UIButton()
    
    private var storageViewModel: FavoriteViewModel
    
    private var pokemonResultViewModel: PokemonResultViewModel
    
    init(pokemonResultViewModel: PokemonResultViewModel,
         storageViewModel: FavoriteViewModel) {
        
        self.pokemonResultViewModel = pokemonResultViewModel
        
        self.storageViewModel = storageViewModel
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setup() {
        
        navigationItem.title = "\(pokemonResultViewModel.name)"
        
        navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = .white
        
        starButton.addTarget(self, action: #selector(didTapStar),
                             for: .touchUpInside)
        
        starButton.isHidden = true
        
        storageViewModel.fetchFavorite(completion: nil)
        
        viewModel.pokemonViewModel.bind { [weak self] pokemonDetailViewModel in
            
            guard let self = self else { return }
            
            self.idLabel.text = pokemonDetailViewModel?.id
            
            self.heightLabel.text = pokemonDetailViewModel?.height
            
            self.weightLabel.text = pokemonDetailViewModel?.weight
            
            self.typeLabel.text = pokemonDetailViewModel?.type.joined(separator: ", ")
            
            if let id = self.viewModel.pokemonViewModel.value?.id {
                
                self.starButton.isSelected = self.storageViewModel.checkIsStar(id: id)
                
                self.updateStarButton()
            }
            
            self.starButton.isHidden = false
            
            let imageUrl = self.pokemonResultViewModel.imageUrl
            
            self.imageView.setImage(urlString: imageUrl, placeholderImage: .asset(.ball_placeholer))
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
        
        starButton.setImage(.systemAsset(.star), for: .normal)
        starButton.setImage(.systemAsset(.starFill), for: .selected)
        starButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        starButton.tintColor = .darkGray
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
        view.addSubview(starButton)
        view.addSubview(VStack)
        
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         centerX: view.centerXAnchor,
                         width: 200,
                         height: 200,
                         padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        starButton.anchor(top: imageView.bottomAnchor,
                          centerX: view.centerXAnchor,
                          width: 50,
                          height: 50,
                          padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        VStack.anchor(top: starButton.bottomAnchor,
                      leading: view.leadingAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      trailing: view.trailingAnchor,
                      padding: UIEdgeInsets(top: 16, left: 20, bottom: 50, right: 20))
    }
    
    @objc private func didTapStar() {
        
        starButton.isSelected = !starButton.isSelected
        
        if starButton.isSelected {
            
            storageViewModel.savePokemon(with: pokemonResultViewModel)
        } else {
            
            storageViewModel.removePokemon(id: pokemonResultViewModel.id)
        }
        
        updateStarButton()
    }
    
    private func updateStarButton() {
        
        if starButton.isSelected {
            
            starButton.tintColor = .systemOrange
        } else {
            
            starButton.tintColor = .darkGray
        }
    }
}
