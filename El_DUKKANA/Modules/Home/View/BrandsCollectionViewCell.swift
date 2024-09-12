//
//  BrandsCollectionViewCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 08/09/2024.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        brandImage.backgroundColor = .white
        
    }
    
}
