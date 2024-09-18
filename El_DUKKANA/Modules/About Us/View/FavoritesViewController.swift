//
//  FavoritesViewController.swift
//  El_DUKKANA
//
//  Created by ios on 13/09/2024.
//

import UIKit
import Alamofire
 
class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FavCellDelegate {
    
    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    @IBOutlet weak var noFavoritesImage: UIImageView!
    
    var productIds : [Int] = []
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    var customerViewModel = CustomerViewModel()
    var favoritesViewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWishlistCollectionView()
        checkIfFavoritesIsEmpty()
        
        for item in CurrentCustomer.currentFavDraftOrder.draft_order.line_items{
            productIds.append(item.product_id ?? 0)
        }
        let commaSeparatedString = productIds.map { String($0) }.joined(separator: ",")
        favoritesViewModel.getproductImage(ids: commaSeparatedString)
        favoritesViewModel.bindResultToViewController2 = {
            print(self.favoritesViewModel.Images)
            self.WishlistCollectionView.reloadData()
        }
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
        
        if CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count == 1 && CurrentCustomer.currentFavDraftOrder.draft_order.line_items[0].title == "ADIDAS | CLASSIC BACKPACK" && CurrentCustomer.currentFavDraftOrder.draft_order.line_items[0].price == "70.00" {
            return 0
        } else{
            return CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: FavCell.self), for: indexPath) as! FavCell
        
        let favItem = CurrentCustomer.currentFavDraftOrder.draft_order.line_items[indexPath.row]
        
        let images = favoritesViewModel.Images
        if let priceString = favItem.price, let price = Double(priceString) {
            let convertedPrice = price * CurrencyManager.shared.currencyRate
            if indexPath.row < images.count {
                cell.configureCell(image: images[indexPath.row],
                                   title: favItem.title ?? "",
                                   price: "\(convertedPrice)",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   favItem: favItem)
            } else {
                cell.configureCell(image: dummyImage , title: favItem.title ?? "", price: "\(convertedPrice)" , currency: CurrencyManager.shared.selectedCurrency, favItem: favItem)
            } } else {
                if indexPath.row < images.count {
                    cell.configureCell(image: images[indexPath.row],
                                       title: favItem.title ?? "",
                                       price: "N/A",
                                       currency: CurrencyManager.shared.selectedCurrency,
                                       favItem: favItem)
                } else {
                    cell.configureCell(image: dummyImage , title: favItem.title ?? "", price: "N/A" , currency: CurrencyManager.shared.selectedCurrency, favItem: favItem)
                }
            }
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
