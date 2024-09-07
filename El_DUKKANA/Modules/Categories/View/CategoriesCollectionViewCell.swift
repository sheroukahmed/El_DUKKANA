//
//  CategoriesCollectionViewCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 07/09/2024.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        productImage.backgroundColor = .white
        productImage.layer.cornerRadius = 20
    }
    
}
