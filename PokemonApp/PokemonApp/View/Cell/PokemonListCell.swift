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
    
    let nameLabel = UILabel()
    
    private let starButton = UIButton()
    
    var pokemonResultViewModel: PokemonResultViewModel?
    
    weak var delegate: PokemonListCellDelegate?
    
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
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        indicatorView.hidesWhenStopped = true
        
        starButton.addTarget(self, action: #selector(didTapStar),
                             for: .touchUpInside)
    }
    
    private func styleObject() {
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        starButton.setImage(.systemAsset(.star), for: .normal)
        starButton.setImage(.systemAsset(.starFill), for: .selected)
        starButton.tintColor = .darkGray
    }
    
    private func layout() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(starButton)
        contentView.addSubview(indicatorView)
        
        nameLabel.anchor(leading: leadingAnchor,
                         centerY: centerYAnchor,
                         padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
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
            
            nameLabel.text = viewModel.name
            
            starButton.isHidden = false
            
            indicatorView.stopAnimating()
            
        } else {
            
            nameLabel.text = ""
            
            starButton.isHidden = true
            
            indicatorView.startAnimating()
        }
        
        starButton.isSelected = isStar
    }
    
    @objc private func didTapStar() {
        
        starButton.isSelected = !starButton.isSelected
        
        self.delegate?.didTapStar(with: self,
                                  isStar: starButton.isSelected)
    }
}
