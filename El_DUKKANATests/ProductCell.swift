//
//  ProductCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 07/09/2024.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCurrency: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImage.backgroundColor = .white
        productImage.layer.cornerRadius = 20
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    func configureCell (image: String, title: String, price: String, currency: String, isFavorited: Bool) {
        productImage.kf.setImage(with: URL(string: image))
        productTitle.text = title
        productPrice.text = price
        productCurrency.text = currency
        if isFavorited {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        
    }
}
