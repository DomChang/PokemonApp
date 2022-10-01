//
//  PokemonListCell.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

protocol PokemonListCellDelegate: AnyObject {
    
    func didTapStar(with cell: PokemonListCell, isStar: Bool)
}

class PokemonListCell: UITableViewCell {
    
    var pokemonResultViewModel: PokemonResultViewModel?
    
    weak var delegate: PokemonListCellDelegate?
    
    private let idLabel = UILabel()
    
    private let nameLabel = UILabel()
    
    private let starButton = UIButton()
    
    private let pokemonImageView = UIImageView()
    
    private let indicatorView = UIActivityIndicatorView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configureCell(with: .none, isStar: false)
        
        starButton.tintColor = .darkGray
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        indicatorView.hidesWhenStopped = true
        
        starButton.addTarget(self, action: #selector(didTapStar),
                             for: .touchUpInside)
    }
    
    private func styleObject() {
        
        pokemonImageView.contentMode = .scaleAspectFill
        pokemonImageView.clipsToBounds = true
        
        idLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        idLabel.textColor = .darkGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .darkGray
        nameLabel.adjustsFontSizeToFitWidth = true
        
        starButton.setImage(.systemAsset(.star), for: .normal)
        starButton.setImage(.systemAsset(.starFill), for: .selected)
        
        starButton.tintColor = .darkGray
    }
    
    private func layout() {
        
        let vStack = UIStackView(arrangedSubviews: [idLabel, nameLabel])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 5
        
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(vStack)
        contentView.addSubview(starButton)
        contentView.addSubview(indicatorView)
        
        pokemonImageView.anchor(leading: leadingAnchor,
                                centerY: centerYAnchor,
                                width: 80,
                                height: 80,
                                padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        vStack.anchor(leading: pokemonImageView.trailingAnchor,
                         trailing: starButton.leadingAnchor,
                         centerY: centerYAnchor,
                         padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8))
        
        starButton.anchor(trailing: trailingAnchor,
                          centerY: centerYAnchor,
                          width: 50,
                          height: 50,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        
        indicatorView.anchor(centerY: centerYAnchor,
                             centerX: centerXAnchor)
    }
    
    func configureCell(with viewModel: PokemonResultViewModel?, isStar: Bool) {
        
        if let viewModel = viewModel {
            
            self.pokemonResultViewModel = viewModel
            
            pokemonImageView.setImage(urlString: viewModel.imageUrl,
                                      placeholderImage: .asset(.ball_placeholer))
            
            DispatchQueue.main.async {
                
                self.idLabel.text = "# " + viewModel.id
                
                self.nameLabel.text = viewModel.name
                
                self.starButton.isHidden = false
                
                self.indicatorView.stopAnimating()
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.idLabel.text = ""
                
                self.nameLabel.text = ""
                
                self.starButton.isHidden = true
                
                self.pokemonImageView.image = nil
                
                self.indicatorView.startAnimating()
            }
        }
        
        starButton.isSelected = isStar
        
        updateStarButton()
    }
    
    @objc private func didTapStar() {
        
        starButton.isSelected = !starButton.isSelected
        
        updateStarButton()
        
        self.delegate?.didTapStar(with: self,
                                  isStar: starButton.isSelected)
    }
    
    private func updateStarButton() {
        
        if starButton.isSelected {
            
            starButton.tintColor = .systemOrange
        } else {
            
            starButton.tintColor = .darkGray
        }
    }
}
