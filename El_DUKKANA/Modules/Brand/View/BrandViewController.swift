//
//  BrandViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 08/09/2024.
//

import UIKit
import Kingfisher
import Alamofire

class BrandViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var BrandProductCollectionView: UICollectionView!
    
    var brandViewModel: BrandViewModel?
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    var isFiltered = false
    var brandImages: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BrandProductCollectionView.delegate = self
        BrandProductCollectionView.dataSource = self
        
        self.BrandProductCollectionView!.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        BrandProductCollectionView.setCollectionViewLayout(layout, animated: true)
        
        brandViewModel = BrandViewModel(brand: brandViewModel?.brand ?? "")
        
        brandViewModel?.getProducts()
        brandViewModel?.bindToBrandViewController = { [weak self] in DispatchQueue.main.async {
            guard let self = self else { return }
            self.BrandProductCollectionView.reloadData()
        }
        }
        
        filterButton.layer.cornerRadius = 17.5
    }
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandViewModel?.products?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
         //brandImages = brandViewModel?.products?[indexPath.row].images?[indexPath.row].src
         
         if isFiltered {
             let brandProduct = brandViewModel?.filteredProducts?[indexPath.row]
             cell.configureCell(image: brandProduct?.image?.src ?? dummyImage, title: brandProduct?.title ?? "", price: brandProduct?.variants?.first?.price ?? "", currency: "USD", isFavorited: false)
         } else {
             let brandProduct = brandViewModel?.products?[indexPath.row]
             cell.configureCell(image: brandProduct?.image?.src ?? dummyImage, title: brandProduct?.title ?? "", price: brandProduct?.variants?.first?.price ?? "", currency: "USD", isFavorited: false)
         }
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

    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let productDetails = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsStoryboard") as! ProductDetailsVC
        
            self.navigationController?.pushViewController(productDetails, animated: true)
        } else {
            let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
*/
    
    func isFilter() {
        if isFiltered {
            filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        } else {
            filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        }
    }
    
    
    @IBAction func filter(_ sender: Any) {
        isFiltered = !isFiltered
        isFilter()
        brandViewModel?.filterProducts()
    }
    
}
