//
//  FavoritesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 13/09/2024.
//

import UIKit
import Alamofire

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"

    var customerViewModel = CustomerViewModel()

    var favoritesViewModel = FavoritesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpWishlistCollectionView()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        customerViewModel.getAllDrafts()
        self.WishlistCollectionView.reloadData()
    }
    
    func setUpWishlistCollectionView() {
        WishlistCollectionView.delegate = self
        WishlistCollectionView.dataSource = self
        
        WishlistCollectionView.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        WishlistCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
        
        let favItem = CurrentCustomer.currentFavDraftOrder.draft_order.line_items[indexPath.row]
            
        cell.configureCell(image:  dummyImage, title: favItem.title ?? "", price: favItem.price ?? "", currency: "USD", isFavorited: true)
        
  
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 5
           let collectionViewWidth = collectionView.frame.width
           let availableWidth = collectionViewWidth - padding * 3
           let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
       }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyBoard = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil)
            if let productDetails = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
                
                productDetails.viewModel.productId = CurrentCustomer.currentFavDraftOrder.draft_order.line_items[indexPath.row].product_id ?? 0
                
                productDetails.modalPresentationStyle = .fullScreen
                productDetails.modalTransitionStyle = .crossDissolve
                self.present(productDetails, animated: true)
            }
        
            
        } else {
            let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }

}
