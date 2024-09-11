//
//  CartViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit

class CartViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var productstableview: UITableView!
    
    @IBOutlet weak var totalprice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productstableview.dataSource = self
        productstableview.delegate = self
        
        productstableview.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")

       
    }
    
    func calculateTotalPrice() {
//            let total = cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
//            totalprice.text = "Total: \(total)$"
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

    
    @IBAction func gotocheckout(_ sender: Any) {
    }
    
}
