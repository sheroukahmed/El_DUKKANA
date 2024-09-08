//
//  CategoriesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 06/09/2024.
//

import UIKit
import Kingfisher
import Alamofire

class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var FirstSegmentedControl: UISegmentedControl!
    @IBOutlet weak var SecondSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ProductsCategoriesCollectionView: UICollectionView!
    
    var categoriesViewModel: CategoriesViewModelProtocol?
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductsCategoriesCollectionView.delegate = self
        ProductsCategoriesCollectionView.dataSource = self
        ProductsCategoriesCollectionView.register(CategoriesCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoriesCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        ProductsCategoriesCollectionView.setCollectionViewLayout(layout, animated: true)
        
        
        categoriesViewModel = CategoriesViewModel()
        
        categoriesViewModel?.getProducts()
        categoriesViewModel?.bindToCategoriesViewController = { [weak self] in DispatchQueue.main.async {
            guard let self = self else { return }
            self.ProductsCategoriesCollectionView.reloadData()
        }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesViewModel?.products?.count ?? 0

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ProductsCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.productImage.kf.setImage(with: URL(string: categoriesViewModel?.products?[indexPath.row].image?.src ?? dummyImage))
        cell.productTitle.text = categoriesViewModel?.products?[indexPath.row].title
        cell.productPrice.text = " 10 "
     //   cell.productPrice.text = categoriesViewModel?.products?[indexPath.row].variants?[indexPath.row].price
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

                
                productDetails.viewModel.productId = self.categoriesViewModel?.products?[indexPath.row].id ?? 1
                
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
  
    

    @IBAction func goToFavorites(_ sender: Any) {
        
    }
    
    @IBAction func goToCart(_ sender: Any) {
        
    }
    
    @IBAction func goToSearch(_ sender: Any) {
        
    }
}
