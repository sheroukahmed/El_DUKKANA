//
//  ProductCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 06/09/2024.
//

import UIKit

class ProductCell: UIView {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
}
