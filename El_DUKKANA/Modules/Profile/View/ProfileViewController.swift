//
//  ProfileViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
 
    
    @IBOutlet weak var NotLoginView: UIView!
    @IBOutlet weak var NotLoginImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBOutlet weak var OrdersTableView: UITableView!
    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var addressesButton: UIButton!
    
    @IBOutlet weak var moreOrdersButton: UIButton!
    @IBOutlet weak var moreWishlistButton: UIButton!
    @IBOutlet weak var userView: UIView!
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    var ordersViewModel: OrdersViewModel?
    var favoritesViewModel: FavoritesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFirstName.text = CurrentCustomer.currentCustomer.first_name
        userEmail.text = CurrentCustomer.currentCustomer.email
        
        getView(isLogin: true)
        
        self.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person.crop.circle.fill"), selectedImage: UIImage(named: "person.crop.circle"))

        setupUI()
        setUpOrderTableView()
        setUpWishlistCollectionView()
        
        ordersViewModel = OrdersViewModel()
        ordersViewModel?.getAllOrders()
        ordersViewModel?.bindToOrders = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.OrdersTableView.reloadData()
            }
        }
        
        favoritesViewModel = FavoritesViewModel()
        favoritesViewModel?.getFavorites()
        favoritesViewModel?.bindToFavorites = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.WishlistCollectionView.reloadData()
            }
        }
    }
    
    func setUpOrderTableView() {
        OrdersTableView.delegate = self
        OrdersTableView.dataSource = self
        
        OrdersTableView.register(UINib(nibName: String(describing: OrderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OrderTableViewCell.self))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrdersTableView.dequeueReusableCell(withIdentifier: String (describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
        
        let order = ordersViewModel?.orders? [indexPath.row]
        
        cell.configureCell(order: order?.name ?? "", orderNoOfItems: order?.line_items?.count ?? 0, orderPrice: order?.total_price ?? "", currency: "USD", date: order?.created_at ?? "")
        
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func setUpWishlistCollectionView() {
            WishlistCollectionView.delegate = self
            WishlistCollectionView.dataSource = self
            
            WishlistCollectionView.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
            
            let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(217), heightDimension: .fractionalHeight(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                section.visibleItemsInvalidationHandler = { (items, offset, environment) in
                    items.forEach { item in
                        let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                        let minScale: CGFloat = 0.8
                        let maxScale: CGFloat = 1.0
                        let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                        item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    }
                }
                return section
            }
            WishlistCollectionView.setCollectionViewLayout(layout, animated: true)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: ProductCell.self), for: indexPath) as! ProductCell
        
        var favItem: Product?
        favItem = favoritesViewModel?.favorites?[indexPath.row]
            
            cell.configureCell(image: favItem?.image?.src ?? dummyImage, title: favItem?.title ?? "", price: favItem?.variants?.first?.price ?? "", currency: "USD", isFavorited: false)
  
        cell.layer.cornerRadius = 20
        return cell
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

    
    private func setupUI(){
        
        loginButton.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 15
        addressesButton.layer.cornerRadius = 15
        moreOrdersButton.layer.cornerRadius = 15
        moreWishlistButton.layer.cornerRadius = 15
        userView.layer.cornerRadius = 20
        OrdersTableView.layer.cornerRadius = 20
        
        let customColor = UIColor(red: 0.403, green: 0.075, blue: 0.067, alpha: 1.0)
        
        self.navigationController?.navigationBar.tintColor = customColor
        
        // Create cart button (right side)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(cartButtonTapped))
        cartButton.tintColor = customColor

        // Create settings button (right side)
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsButtonTapped))
        settingsButton.tintColor = customColor
        
        // Set right bar buttons (Cart and Settings)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
         spacer.width = 1
         navigationItem.rightBarButtonItems = [settingsButton, spacer, cartButton]
        
    }
    
    func getView(isLogin: Bool) {
        NotLoginView.isHidden = isLogin
        NotLoginImage.isHidden = isLogin
        loginButton.isHidden = isLogin
        registerButton.isHidden = isLogin
        haveAnAccountLabel.isHidden = isLogin
    }
    
    @objc func cartButtonTapped() {
        print("Cart button tapped")
        let storyboard = UIStoryboard(name: "CartStoryboard", bundle: nil)
        if let cart = storyboard.instantiateViewController(withIdentifier: "CartStoryboard") as? CartViewController {
            cart.title = "My Cart"
            self.navigationController?.pushViewController(cart, animated: true)
        }
    }

    @objc func settingsButtonTapped() {
        print("Settings button tapped")
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        if let settings = storyboard.instantiateViewController(withIdentifier: "SettingsStoryboard") as? SettingsViewController {
            settings.title = "Settings"
            self.navigationController?.pushViewController(settings, animated: true)
        }
    }
    
    @IBAction func seeMoreOrders(_ sender: Any) {
        if let orders = self.storyboard?.instantiateViewController(withIdentifier: "myOrders") as? OrdersViewController {
            orders.title = "My Orders"
            self.navigationController?.pushViewController(orders, animated: true)
        }
    }
    
    @IBAction func seeMoreWishlist(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FavoritesStoryboard", bundle: nil)
        if let favorites = storyboard.instantiateViewController(withIdentifier: "Favorites") as? FavoritesViewController {
            favorites.title = "My Wishlist"
            self.navigationController?.pushViewController(favorites, animated: true)
        }
    }
    
    
    @IBAction func goToAddresses(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddressesStoryboard", bundle: nil)
        if let addresses = storyboard.instantiateViewController(withIdentifier: "Addresses") as? AddressesViewController {
            addresses.title = "My Addresses"
            self.navigationController?.pushViewController(addresses, animated: true)
        }
    }
    
    @IBAction func toLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signInVC = storyboard.instantiateViewController(identifier: "SignInVC")
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.modalTransitionStyle = .crossDissolve
       present(signInVC, animated: true)
    }
    
    @IBAction func toRegister(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(identifier: "SignUpVC")
        signUpVC.modalPresentationStyle = .fullScreen
        signUpVC.modalTransitionStyle = .crossDissolve
       present(signUpVC, animated: true)
    }
}
