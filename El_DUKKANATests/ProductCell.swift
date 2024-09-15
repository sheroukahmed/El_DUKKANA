//
//  ProductCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 07/09/2024.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: AnyObject {
    func presentAlert(_ alert: UIAlertController)
    func presentSignInVC()
    func refreshCollectionView()
}
 
class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCurrency: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var product = Product(id: 0, title: "", body_html: "", vendor: "", product_type: "", tags: "", variants: [], options: [], images: [], image: ProductImage(id: 0, position: 0, src: ""))
    var isFavorited = false
    var viewModel = ProductDetailsViewModel()
    
    weak var delegate: ProductCellDelegate?
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
        print("Fav Button Pressed")
                
                if CurrentCustomer.currentCustomer.email != nil {
                    for item in CurrentCustomer.currentFavDraftOrder.draft_order.line_items {
                        print("\n\n\n \(product.id)\n\n")
                        if self.product.id == item.product_id ?? 0 {
                            self.isFavorited = true
                            break
                        } else {
                            self.isFavorited = false
                        }
                    }
                    handleFavorites()
                } else {
                    // Show sign-in alert
                    let alert = UIAlertController(title: "SignIn First", message: "You can't add to Fav you have to sign in first", preferredStyle: .alert)
                    let signIn = UIAlertAction(title: "SignIn", style: .default) { action in
                        self.delegate?.presentSignInVC()
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(signIn)
                    alert.addAction(cancel)
                    delegate?.presentAlert(alert)
                }
            }
            
            func handleFavorites() {
                if !isFavorited {
                    print(self.product)
                    // Add to favorites
                    
                        let productToFav = LineItem(id: 7482947, variant_id: product.variants?[0].id, product_id: product.id, title: product.title, variant_title: product.variants?[0].title, vendor: product.vendor, quantity: 1, name: "", custom: false, price: product.variants?[0].price, properties: [(ProductProperties(image: product.image?.src ?? "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"))])
                        
                        CurrentCustomer.currentFavDraftOrder.draft_order.line_items.append(productToFav)
                        CurrentCustomer.currentFavDraftOrder.draft_order.line_items.removeAll { $0.price == "70.00" }
                        
                        let alert = UIAlertController(title: "Product Added to Fav", message: "The product has been added to Fav successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default) { action in
                            self.isFavorited.toggle()
                            self.setBtnView()
                            self.viewModel.updateFavDraftOrder()
                            self.delegate?.refreshCollectionView()
         
                        }
                        alert.addAction(ok)
                        delegate?.presentAlert(alert)
                    
                } else {
                    // Remove from favorites
                    let alert = UIAlertController(title: "Removing from the wish list", message: "Are you sure you want to delete this product from the wish list?", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Yes", style: .destructive) { action in
                        self.isFavorited.toggle()
                        self.setBtnView()
                        CurrentCustomer.currentFavDraftOrder.draft_order.line_items.removeAll { $0.title == self.product.title }
                        self.viewModel.updateFavDraftOrder()
                        self.delegate?.refreshCollectionView()
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    delegate?.presentAlert(alert)
                }
            }
            
            func setBtnView() {
                updateFavoriteButton(isFavorited: isFavorited)
            }
            
            private func updateFavoriteButton(isFavorited: Bool) {
                let imageName = isFavorited ? "heart.fill" : "heart"
                favButton.setImage(UIImage(systemName: imageName), for: .normal)
            
    }
}
