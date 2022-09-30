//
//  PokemonListCell.swift
//  PokemonApp
//
//  Created by ChunKai Chang on 2022/9/30.
//

import UIKit

class PokemonListCell: UITableViewCell {
    
    let nameLabel = UILabel()

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
    }
    
    private func setup() {
        
        selectionStyle = .none
    }
    
    private func styleObject() {
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func layout() {
        
        contentView.addSubview(nameLabel)
        
        nameLabel.anchor(leading: leadingAnchor,
                         centerY: centerYAnchor,
                         padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    func configureCell(with viewModel: PokemonResultViewModel) {
        
        nameLabel.text = viewModel.name
    }
}
