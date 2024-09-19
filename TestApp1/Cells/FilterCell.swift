//
//  FilterCell.swift
//  TestApp2
//
//  Created by Raul Shafigin on 18.09.2024.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func configureCell(with text: String) {
        titleLabel.text = text
        self.layer.cornerRadius = 16
        self.backgroundColor = .clear
        self.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9176470588, alpha: 1)
        self.layer.borderWidth = 1
    }
    
    func configureFirstCell() {
        self.layer.borderWidth = 0
        self.backgroundColor = #colorLiteral(red: 1, green: 0.1803921569, blue: 0, alpha: 1)
        titleLabel.textColor = .white
    }
}
