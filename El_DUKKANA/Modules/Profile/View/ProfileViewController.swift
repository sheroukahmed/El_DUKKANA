//
//  ProfileViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var OrdersTableView: UITableView!
    @IBOutlet weak var WishlistCollectionView: UICollectionView!
    
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
   
    @IBOutlet weak var moreOrdersButton: UIButton!
    @IBOutlet weak var moreWishlistButton: UIButton!
    @IBOutlet weak var userView: UIView!
    
    
    var ordersViewModel: OrdersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFirstName.text = CurrentCustomer.currentCustomer.first_name
        userEmail.text = CurrentCustomer.currentCustomer.email
        
        self.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person.crop.circle.fill"), selectedImage: UIImage(named: "person.crop.circle"))

        setupUI()
        setUpOrderTableView()
        
        ordersViewModel = OrdersViewModel()
        ordersViewModel?.getAllOrders()
        ordersViewModel?.bindToOrders = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.OrdersTableView.reloadData()
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
    
    
    private func setupUI(){
        
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
        
    }
}
