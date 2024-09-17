//
//  CategoriesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 06/09/2024.
//

import UIKit
import Kingfisher
import Alamofire
import RxSwift
import RxCocoa


class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ProductCellDelegate   {
    @IBOutlet weak var searchBarBackBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var FirstSegmentedControl: UISegmentedControl!
    @IBOutlet weak var SecondSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ProductsCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var NoProductsAvailableImage: UIImageView!
    
    var startSearch = false
    var isSearching = false
    var searchViewModel = SearchViewModel()
    var categoriesViewModel: CategoriesViewModel?
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    let disposeBag = DisposeBag()
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Color 1")
        ProductsCategoriesCollectionView.backgroundColor = UIColor(named: "Color 1")
        
        print(CurrentCustomer.currentCustomer)
        searchBarBackBtn.isHidden = true
        searchBar.isHidden = true
        setupUI()
        
        categoriesViewModel = CategoriesViewModel()
        
        categoriesViewModel?.bindToCategoriesViewController = { [weak self] in DispatchQueue.main.async {
            self?.indicator?.stopAnimating()
            guard let self = self else { return }
            self.ProductsCategoriesCollectionView.reloadData()
            self.toggleNoDataView()
            self.searchViewModel.allProducts = self.categoriesViewModel?.products ?? []
        }
        }
        
        
        Observable.combineLatest(
            FirstSegmentedControl.rx.selectedSegmentIndex.map { index -> CollectionID in
                switch index {
                case 1: return .men
                case 2: return .women
                case 3: return .kids
                case 4: return .sale
                default: return .all
                }
            },
            SecondSegmentedControl.rx.selectedSegmentIndex.map { index -> ProductType in
                switch index {
                case 1: return .t_shirt
                case 2: return .accessories
                default: return .shoes
                }
            }
        )
        .subscribe(onNext: { [weak self] collectionId, productType in
            if collectionId == .all {
                self?.categoriesViewModel?.getAllProducts()
                self?.SecondSegmentedControl.isHidden = true
            } else {
                self?.SecondSegmentedControl.isHidden = false
                self?.categoriesViewModel?.getProducts(collectionId: collectionId, productType: productType)
            }
        })
        .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProductsCategoriesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchViewModel.filterdProducts.count : (categoriesViewModel?.products?.count ?? 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
        
        var product: Product?
        if isSearching {
            product = searchViewModel.filterdProducts[indexPath.row]
        } else {
            product = categoriesViewModel?.products?[indexPath.row]
        }
        if let priceString = product?.variants?.first?.price, let price = Double(priceString) {
            let convertedPrice = price * CurrencyManager.shared.currencyRate
            cell.configureCell(image: product?.image?.src ?? dummyImage,
                               title: product?.title ?? "",
                               price: "\(convertedPrice)",
                               currency: CurrencyManager.shared.selectedCurrency,
                               isFavorited: false)
        } else {
            cell.configureCell(image: product?.image?.src ?? dummyImage,
                               title: product?.title ?? "",
                               price: "N/A",
                               currency: CurrencyManager.shared.selectedCurrency,
                               isFavorited: false)
        }
        cell.delegate = self
        cell.product = product!
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
            UIAlertController.showNoConnectionAlert(self: self)        }
    }
    
    private func setupUI() {
        
        let customColor = UIColor(red: 0.403, green: 0.075, blue: 0.067, alpha: 1.0)
        
        self.navigationController?.navigationBar.tintColor = customColor
        
        // Create search button (left side)
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(searchButtonTapped))
        searchButton.tintColor = customColor
        
        // Create cart button (right side)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(cartButtonTapped))
        cartButton.tintColor = customColor
        
        // Create favorite button (right side)
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteButtonTapped))
        favoriteButton.tintColor = customColor
        
        // Set left bar button (Search)
        navigationItem.leftBarButtonItem = searchButton
        
        // Set right bar buttons (Cart and Favorite)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 1
        navigationItem.rightBarButtonItems = [favoriteButton, spacer, cartButton]
        
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
        ProductsCategoriesCollectionView.delegate = self
        ProductsCategoriesCollectionView.dataSource = self
        ProductsCategoriesCollectionView.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        ProductsCategoriesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func toggleNoDataView() {
        guard let viewModel = categoriesViewModel else { return }
        let noProducts = categoriesViewModel?.products?.isEmpty ?? true
        if viewModel.isLoading {
            indicator?.startAnimating()
            ProductsCategoriesCollectionView.isHidden = false
            NoProductsAvailableImage.isHidden = true
        } else {
            ProductsCategoriesCollectionView.isHidden = noProducts
            NoProductsAvailableImage.isHidden = !noProducts
        }
    }
    
    
    @objc func searchButtonTapped() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            if startSearch {
                self.searchBar.isHidden = false
                self.searchBarBackBtn.isHidden = false
                startSearch = startSearch ? false : true
            } else{
                self.searchBar.isHidden = true
                self.searchBarBackBtn.isHidden = true
                startSearch = startSearch ? false : true
            }
        } else {
            UIAlertController.showNoConnectionAlert(self: self)        }
    }
    
    @objc func cartButtonTapped() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            if CurrentCustomer.currentCustomer.email != nil {
                let storyboard = UIStoryboard(name: "CartStoryboard", bundle: nil)
                if let cart = storyboard.instantiateViewController(withIdentifier: "CartStoryboard") as? CartViewController {
                    cart.title = "My Cart"
                    self.navigationController?.pushViewController(cart, animated: true)
                }
            } else {
                UIAlertController.showGuestAlert(self: self)
            }} else {
                UIAlertController.showNoConnectionAlert(self: self)
            }
    }
    
    
    @objc func favoriteButtonTapped() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            if CurrentCustomer.currentCustomer.email != nil {
                let storyboard = UIStoryboard(name: "FavoritesStoryboard", bundle: nil)
                if let favorites = storyboard.instantiateViewController(withIdentifier: "Favorites") as? FavoritesViewController {
                    favorites.title = "My Wishlist"
                    self.navigationController?.pushViewController(favorites, animated: true)
                }
            } else {
                UIAlertController.showGuestAlert(self: self)
            }} else {
                UIAlertController.showNoConnectionAlert(self: self)            }
    }
    
    
    
    @IBAction func searchBackBtn(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            self.searchBar.isHidden = true
            self.searchBarBackBtn.isHidden = true
        } else {
            UIAlertController.showNoConnectionAlert(self: self)
        }
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
        self.ProductsCategoriesCollectionView.reloadData()
    }
    
    
}
extension CategoriesViewController: UISearchBarDelegate{
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
        ProductsCategoriesCollectionView.reloadData()
        }
}
