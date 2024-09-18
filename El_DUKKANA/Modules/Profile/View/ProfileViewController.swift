//
//  ProfileViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, FavCellDelegate {
    
    
    @IBOutlet weak var NotLoginView: UIView!
    @IBOutlet weak var NotLoginImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBOutlet weak var noFavoritesImage: UIImageView!
    @IBOutlet weak var OrdersTableView: UITableView!
    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var addressesButton: UIButton!
    
    @IBOutlet weak var moreOrdersButton: UIButton!
    @IBOutlet weak var moreWishlistButton: UIButton!
    @IBOutlet weak var userView: UIView!
    
    static var isUser = true
    var viewModel = ProfileViewModel()
    var productIds : [Int] = []
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    var ordersViewModel: OrdersViewModel?
    var favoritesViewModel: FavoritesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFirstName.text = CurrentCustomer.currentCustomer.first_name
        userEmail.text = CurrentCustomer.currentCustomer.email
        
        
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
    override func viewWillAppear(_ animated: Bool) {
        for item in CurrentCustomer.currentFavDraftOrder.draft_order.line_items{
                    productIds.append(item.product_id ?? 0)
                }
                let commaSeparatedString = productIds.map { String($0) }.joined(separator: ",")
                viewModel.getproductImage(ids: commaSeparatedString)
                viewModel.bindResultToViewController2 = {
                    print(self.viewModel.Images)
                    self.WishlistCollectionView.reloadData()
                }
        if CurrentCustomer.currentCustomer.email != nil {
            ProfileViewController.isUser = true
            noFavoritesImage.isHidden = false
        }
        else {
            ProfileViewController.isUser = false
            noFavoritesImage.isHidden = true
        }
        getView(isLogin: ProfileViewController.isUser )
        OrdersTableView.reloadData()
        WishlistCollectionView.reloadData()
    }
    
    func setUpOrderTableView() {
        OrdersTableView.delegate = self
        OrdersTableView.dataSource = self
        
        OrdersTableView.register(UINib(nibName: String(describing: OrderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OrderTableViewCell.self))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ProfileViewController.isUser {
            if ordersViewModel?.orders?.count ?? 0 > 2 {
                return 2
            } else {
                return ordersViewModel?.orders?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrdersTableView.dequeueReusableCell(withIdentifier: String (describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
        
        let order = ordersViewModel?.orders?[indexPath.row]
        
        cell.configureCell(order: order?.name ?? "", orderNoOfItems: order?.line_items?.count ?? 0, orderPrice: order?.total_price ?? "", currency: order?.currency ?? "", date: order?.created_at ?? "")
        
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func setUpWishlistCollectionView() {
        WishlistCollectionView.delegate = self
        WishlistCollectionView.dataSource = self
        
        WishlistCollectionView.register(UINib(nibName: String(describing: FavCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FavCell.self))
        
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
        if ProfileViewController.isUser {
            if CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count > 4 {
                return 4
            } else if CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count == 1 && CurrentCustomer.currentFavDraftOrder.draft_order.line_items[0].title == "ADIDAS | CLASSIC BACKPACK" && CurrentCustomer.currentFavDraftOrder.draft_order.line_items[0].price == "70.00" {
                return 0
            }
            
            else {
                return CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count
            }
        }
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: FavCell.self), for: indexPath) as! FavCell
            
            let favItem = CurrentCustomer.currentFavDraftOrder.draft_order.line_items[indexPath.row]
            
            let images = viewModel.Images
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
        }}
    
    
    private func setupUI(){
        
        loginButton.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 15
        addressesButton.layer.cornerRadius = 8
        moreOrdersButton.layer.cornerRadius = 10
        moreWishlistButton.layer.cornerRadius = 10
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
                UIAlertController.showNoConnectionAlert(self: self)        }
    }
    
    @objc func settingsButtonTapped() {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
            if let settings = storyboard.instantiateViewController(withIdentifier: "SettingsStoryboard") as? SettingsViewController {
                settings.title = "Settings"
                
                self.navigationController?.pushViewController(settings, animated: true)
            }} else {
                UIAlertController.showNoConnectionAlert(self: self)    }
    }
    
    @IBAction func seeMoreOrders(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            if let orders = self.storyboard?.instantiateViewController(withIdentifier: "myOrders") as? OrdersViewController {
                orders.title = "My Orders"
                self.navigationController?.pushViewController(orders, animated: true)
            }} else {
                UIAlertController.showNoConnectionAlert(self: self)        }
    }
    
    @IBAction func seeMoreWishlist(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyboard = UIStoryboard(name: "FavoritesStoryboard", bundle: nil)
            if let favorites = storyboard.instantiateViewController(withIdentifier: "Favorites") as? FavoritesViewController {
                favorites.title = "My Wishlist"
                self.navigationController?.pushViewController(favorites, animated: true)
            }} else {
                UIAlertController.showNoConnectionAlert(self: self)        }
    }
    
    
    @IBAction func goToAddresses(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyboard = UIStoryboard(name: "AddressesStoryboard", bundle: nil)
            if let addresses = storyboard.instantiateViewController(withIdentifier: "Addresses") as? AddressesViewController {
                addresses.title = "My Addresses"
                self.navigationController?.pushViewController(addresses, animated: true)
            }} else {
                UIAlertController.showNoConnectionAlert(self: self)        }
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
    func checkIfFavoritesIsEmpty() {
        if CurrentCustomer.currentFavDraftOrder.draft_order.line_items.count == 1  {
            
            WishlistCollectionView.isHidden = true
            noFavoritesImage.isHidden = false
        }else{
            WishlistCollectionView.isHidden = false
            noFavoritesImage.isHidden = true
        }
        
    }
    
    
}
