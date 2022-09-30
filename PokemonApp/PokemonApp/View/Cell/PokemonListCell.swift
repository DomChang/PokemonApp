//
//  PokemonListCell.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class PokemonListCell: UITableViewCell {
    
    let nameLabel = UILabel()
    
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
        
        configureCell(with: .none)
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        indicatorView.hidesWhenStopped = true
    }
    
    private func styleObject() {
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func layout() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(indicatorView)
        
        nameLabel.anchor(leading: leadingAnchor,
                         centerY: centerYAnchor,
                         padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        indicatorView.anchor(centerY: centerYAnchor,
                             centerX: centerXAnchor)
    }
    
    func configureCell(with viewModel: PokemonResultViewModel?) {
        
        if let viewModel = viewModel {
            
            nameLabel.text = viewModel.name
            
            indicatorView.stopAnimating()
            
        } else {
            
            nameLabel.text = ""
            
            indicatorView.startAnimating()
        }
    }
}
