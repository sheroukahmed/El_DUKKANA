//
//  FavoritesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 13/09/2024.
//

import UIKit
import Alamofire

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FavCellDelegate {
    
    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    @IBOutlet weak var noFavoritesImage: UIImageView!
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    var customerViewModel = CustomerViewModel()
    var favoritesViewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWishlistCollectionView()
        checkIfFavoritesIsEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customerViewModel.getAllDrafts()
        checkIfFavoritesIsEmpty()
        self.WishlistCollectionView.reloadData()
    }
    
    func setUpWishlistCollectionView() {
        WishlistCollectionView.delegate = self
        WishlistCollectionView.dataSource = self
        
        WishlistCollectionView.register(UINib(nibName: String(describing: FavCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FavCell.self))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        WishlistCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count
        checkIfFavoritesIsEmpty()
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: FavCell.self), for: indexPath) as! FavCell
        
        let favItem = CurrentCustomer.currentFavDraftOrder.draft_order.line_items[indexPath.row]
        
        cell.configureCell(image: favoritesViewModel.productImg ?? dummyImage, title: favItem.title ?? "", price: favItem.price ?? "", currency: "USD", favItem: favItem)
        
        cell.delegate = self
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
            UIAlertController.showNoConnectionAlert(self: self)
        }
    }
    
    func checkIfFavoritesIsEmpty() {
        let isEmpty = CurrentCustomer.currentFavDraftOrder.draft_order.line_items.isEmpty
        
        WishlistCollectionView.isHidden = isEmpty
        noFavoritesImage.isHidden = !isEmpty
    }
    
    func presentAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func presentSignInVC() {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
            signInVC.modalTransitionStyle = .crossDissolve
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: true)
        }
    }
    
    func refreshCollectionView() {
        self.WishlistCollectionView.reloadData()
    }
    
    
}
