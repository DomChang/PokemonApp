//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class DetailViewController: BaseViewController {
    
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
    
    private let backView = UIView()
    
    private let circleView = UIView()
    
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private var pokemonResultViewModel: PokemonResultViewModel
    
    init(pokemonResultViewModel: PokemonResultViewModel) {
        
        self.pokemonResultViewModel = pokemonResultViewModel
        
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
        
        hideViews()
        
        indicatorView.startAnimating()
        
        viewModel.fetchErrorHandler = { [weak self] error in
            
            self?.showAlertWithOK(title: "OOPs", message: "\(error)")
        }
        
        favoriteViewModel.fetchFavorite(completion: nil)
        
        viewModel.pokemonViewModel.bind { [weak self] pokemonDetailViewModel in
            
            guard let self = self else { return }
            
            if let type = pokemonDetailViewModel?.type.first {
               
                self.view.backgroundColor = .paColor(name: type)
            }
            
            self.idLabel.text = pokemonDetailViewModel?.id
            
            self.heightLabel.text = pokemonDetailViewModel?.height
            
            self.weightLabel.text = pokemonDetailViewModel?.weight
            
            self.typeLabel.text = pokemonDetailViewModel?.type.joined(separator: ", ")
            
            if let id = self.viewModel.pokemonViewModel.value?.id {
                
                self.starButton.isSelected = self.favoriteViewModel.checkIsStar(id: id)
                
                self.updateStarButton()
            }
            
            self.showViews()
            
            let imageUrl = self.pokemonResultViewModel.imageUrl
            
            self.imageView.setImage(urlString: imageUrl, placeholderImage: .asset(.ball_placeholer))
            
            self.indicatorView.stopAnimating()
        }
        
        viewModel.fetchDetail()
        
    }
    
    private func style() {
        
        idTitleLabel.text = "ID"
        idTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        idTitleLabel.textColor = .black
        
        idLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        idLabel.textColor = .darkGray
        
        heightTitleLabel.text = "HEIGHT"
        heightTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        heightTitleLabel.textColor = .black
        
        heightLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        heightLabel.textColor = .darkGray
        
        weightTitleLabel.text = "WEIGHT"
        weightTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        weightTitleLabel.textColor = .black
        
        weightLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        weightLabel.textColor = .darkGray
        
        typeTitleLabel.text = "TYPES"
        typeTitleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        typeTitleLabel.textColor = .black
        
        typeLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        typeLabel.textColor = .darkGray
        
        starButton.setImage(.systemAsset(.starFill), for: .normal)
        starButton.setImage(.systemAsset(.starFill), for: .selected)
        starButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        starButton.tintColor = .darkGray
        
        backView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        circleView.backgroundColor = .darkGray
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
        
        view.addSubview(backView)
        view.addSubview(circleView)
        view.addSubview(imageView)
        view.addSubview(starButton)
        view.addSubview(VStack)
        view.addSubview(indicatorView)
        
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         centerX: view.centerXAnchor,
                         width: 200,
                         height: 200,
                         padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        
        starButton.anchor(top: imageView.bottomAnchor,
                          centerX: view.centerXAnchor,
                          width: 50,
                          height: 50,
                          padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        VStack.anchor(top: starButton.bottomAnchor,
                      leading: view.leadingAnchor,
                      trailing: view.trailingAnchor,
                      height: 200,
                      padding: UIEdgeInsets(top: 16, left: 70, bottom: 0, right: 20))
        
        backView.anchor(top: starButton.centerYAnchor,
                        leading: view.leadingAnchor,
                        bottom: view.bottomAnchor,
                        trailing: view.trailingAnchor)
        
        circleView.anchor(centerY: starButton.centerYAnchor,
                          centerX: starButton.centerXAnchor,
                          width: 70,
                          height: 70)
        
        indicatorView.anchor(centerY: view.centerYAnchor,
                             centerX: view.centerXAnchor)
        
        backView.layer.cornerRadius = 30
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        circleView.layer.cornerRadius = 35
    }
    
    @objc private func didTapStar() {
        
        starButton.isSelected = !starButton.isSelected
        
        if starButton.isSelected {
            
            favoriteViewModel.savePokemon(with: pokemonResultViewModel)
        } else {
            
            favoriteViewModel.removePokemon(id: pokemonResultViewModel.id)
        }
        
        updateStarButton()
    }
    
    private func updateStarButton() {
        
        if starButton.isSelected {
            
            starButton.tintColor = .systemOrange
        } else {
            
            starButton.tintColor = .white
        }
    }
    
    private func hideViews() {
        
        backView.isHidden = true
        circleView.isHidden = true
        starButton.isHidden = true
    }
    
    private func showViews() {
        
        backView.isHidden = false
        circleView.isHidden = false
        starButton.isHidden = false
    }
}
