//
//  OrdersViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 12/09/2024.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var OrdersTableView: UITableView!
    
    var ordersViewModel: OrdersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return ordersViewModel?.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrdersTableView.dequeueReusableCell(withIdentifier: String (describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
        
        let order = ordersViewModel?.orders? [indexPath.row]
        
        cell.configureCell(order: order?.name ?? "", orderNoOfItems: order?.line_items?.count ?? 0, orderPrice: order?.total_price ?? "", currency: "USD", date: order?.created_at ?? "")
        
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }

    

}
