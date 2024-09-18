//
//  FavCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 16/09/2024.
//

import UIKit
import Kingfisher
 
protocol FavCellDelegate: AnyObject {
    func presentAlert(_ alert: UIAlertController)
    func presentSignInVC()
    func refreshCollectionView()
}
 
class FavCell: UICollectionViewCell {
 
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favTitle: UILabel!
    @IBOutlet weak var favPrice: UILabel!
    @IBOutlet weak var favCurrency: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var favItem = LineItem(variant_id: 0, product_id: 0, title: "", variant_title: "", vendor: "", name: "", custom: true, price: "", properties: [])
    var viewModel = ProductDetailsViewModel()
    weak var delegate: FavCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favImage.backgroundColor = .white
        favImage.layer.cornerRadius = 20
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configureCell (image: String, title: String, price: String, currency: String, favItem: LineItem) {
        favImage.kf.setImage(with: URL(string: image))
        favTitle.text = title
        favPrice.text = price
        favCurrency.text = currency
        
        self.favItem = favItem
        
    }
    
    @IBAction func removeFromFavorites(_ sender: Any) {
        
           let alert = UIAlertController(
               title: "Removing from the wish list",
               message: "Are you sure you want to delete this product from the wish list?",
               preferredStyle: .alert
           )
           let ok = UIAlertAction(title: "Yes", style: .destructive) { action in
               CurrentCustomer.currentFavDraftOrder.draft_order.line_items.removeAll { $0.title == self.favItem.title }
              
               self.viewModel.updateFavDraftOrder()
               self.delegate?.refreshCollectionView()
           }
           let cancel = UIAlertAction(title: "Cancel", style: .cancel)
           alert.addAction(ok)
           alert.addAction(cancel)
 
           delegate?.presentAlert(alert)
    }
    
}
