//
//  FavoritesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 13/09/2024.
//

import UIKit
import Alamofire

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"

    var favoritesViewModel: FavoritesViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpWishlistCollectionView()
        
        favoritesViewModel = FavoritesViewModel()
        favoritesViewModel?.getFavorites()
        favoritesViewModel?.bindToFavorites = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.WishlistCollectionView.reloadData()
            }
        }
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
        return favoritesViewModel?.favorites?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
        
        var favItem: Product?
        favItem = favoritesViewModel?.favorites?[indexPath.row]
            
            cell.configureCell(image: favItem?.image?.src ?? dummyImage, title: favItem?.title ?? "", price: favItem?.variants?.first?.price ?? "", currency: "USD", isFavorited: true)
  
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
                
                productDetails.viewModel.productId = self.favoritesViewModel?.favorites?[indexPath.row].id ?? 1
                
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
