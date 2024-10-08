//
//  BrandViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 08/09/2024.
//

import UIKit
import Kingfisher
import Alamofire

class BrandViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ProductCellDelegate {
    
    var hidden : Bool = false
    @IBOutlet weak var eldukkanaImg: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var BrandProductCollectionView: UICollectionView!
    @IBOutlet weak var NoProductsAvailableImage: UIImageView!
    
    var isSearching = false
    var searchViewModel = SearchViewModel()
    
    var brandViewModel: BrandViewModel?
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    var isFiltered = false
    var brandImages: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Color 1")
        BrandProductCollectionView.backgroundColor = UIColor(named: "Color 1")
        print(CurrentCustomer.currentCustomer)
        setupUI()
        
        brandViewModel = BrandViewModel(brand: brandViewModel?.brand ?? "")
        
        brandViewModel?.getProducts()
        brandViewModel?.bindToBrandViewController = { [weak self] in DispatchQueue.main.async {
            guard let self = self else { return }
            self.BrandProductCollectionView.reloadData()
            self.toggleNoDataView()
            self.searchViewModel.allProducts = self.brandViewModel?.allProducts ?? []
        }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchViewModel.filterdProducts.count : (brandViewModel?.products?.count ?? 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
        
        if isSearching {
            let product = searchViewModel.filterdProducts[indexPath.row]
            if let priceString = product.variants?.first?.price, let price = Double(priceString) {
                let convertedPrice = price * CurrencyManager.shared.currencyRate
                cell.configureCell(image: product.image?.src ?? dummyImage,
                                   title: product.title ?? "",
                                   price: "\(convertedPrice)",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   isFavorited: false)
            } else {
                cell.configureCell(image: product.image?.src ?? dummyImage,
                                   title: product.title ?? "",
                                   price: "N/A",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   isFavorited: false)
            }
            cell.delegate = self
            cell.product = product
            
        } else if isFiltered {
            let brandProduct = brandViewModel?.filteredProducts?[indexPath.row]
            if let priceString = brandProduct?.variants?.first?.price, let price = Double(priceString) {
                let convertedPrice = price * CurrencyManager.shared.currencyRate
                cell.configureCell(image: brandProduct?.image?.src ?? dummyImage,
                                   title: brandProduct?.title ?? "",
                                   price: "\(convertedPrice)",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   isFavorited: false)
            } else {
                cell.configureCell(image: brandProduct?.image?.src ?? dummyImage,
                                   title: brandProduct?.title ?? "",
                                   price: "N/A",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   isFavorited: false)
            }
            cell.delegate = self
            cell.product = brandProduct!
        } else {
            let brandProduct = brandViewModel?.products?[indexPath.row]
            if let priceString = brandProduct?.variants?.first?.price, let price = Double(priceString) {
                let convertedPrice = price * CurrencyManager.shared.currencyRate
                cell.configureCell(image: brandProduct?.image?.src ?? dummyImage,
                                   title: brandProduct?.title ?? "",
                                   price: "\(convertedPrice)",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   isFavorited: false)
            } else {
                cell.configureCell(image: brandProduct?.image?.src ?? dummyImage,
                                   title: brandProduct?.title ?? "",
                                   price: "N/A",
                                   currency: CurrencyManager.shared.selectedCurrency,
                                   isFavorited: false)
            }
            cell.delegate = self
            cell.product = brandProduct!
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyBoard = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil)
            if let productDetails = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
                
                productDetails.viewModel.productId = self.brandViewModel?.products?[indexPath.row].id ?? 1
                
                productDetails.modalPresentationStyle = .fullScreen
                productDetails.modalTransitionStyle = .crossDissolve
                self.present(productDetails, animated: true)
            }
        } else {
            UIAlertController.showNoConnectionAlert(self: self)
        }
    }
    
    
    func isFilter() {
        if isFiltered {
            filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        } else {
            filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        }
    }
    
    private func setupUI() {
        BrandProductCollectionView.delegate = self
        BrandProductCollectionView.dataSource = self
        
        updateView(isHidden: hidden)
        
        self.BrandProductCollectionView!.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        BrandProductCollectionView.setCollectionViewLayout(layout, animated: true)
        
        filterButton.layer.cornerRadius = 17.5
    }
    
    private func toggleNoDataView() {
        if !isSearching {
            let noProducts = brandViewModel?.products?.isEmpty ?? true
            BrandProductCollectionView.isHidden = noProducts
            NoProductsAvailableImage.isHidden = !noProducts
        }
    }
    
    private func updateView(isHidden: Bool) {
        eldukkanaImg.isHidden = isHidden
        searchBar.isHidden = isHidden
        filterButton.isHidden = !isHidden
    }
    
    @IBAction func filter(_ sender: Any) {
        isFiltered = !isFiltered
        isFilter()
        brandViewModel?.filterProducts()
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
            self.BrandProductCollectionView.reloadData()
        }
}

extension BrandViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchViewModel.filterdProducts = []
        } else {
            isSearching = true
            searchViewModel.filterdProducts = searchViewModel.allProducts.filter { product in
                product.title?.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        BrandProductCollectionView.reloadData()
    }
}
