//
//  CartViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit


class CartViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var productstableview: UITableView!
    let viewMode : CartViewModel = CartViewModel()
    @IBOutlet weak var totalprice: UILabel!
    var customer = Customer(id: 7828790968558, email: "samir7.sherouk@gmail.com", first_name: "sara", last_name: "And sherouk", phone: "+201165015450", verified_email: true, addresses: [CustomerAddress(address1: "sherouk", address2: "Lastnameson", city: "Ottawa", province: "Ontario", country: "Canada", zip: "123 ABC")], password: "123abc", password_confirmation: "123abc")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMode.customerDraft = (DraftOrderRequest(draft_order: DraftOrder(id: 342523443, email: "sherouk@gmail.com", currency: "USD", created_at: "2024-9-4", updated_at: "2024-9-7", completed_at: "2024-9-9", name: "#D3", status: "open",line_items: [LineItem(id: 1066630380, variant_id: nil, product_id: nil, title: "Custom Tee", variant_title: "", vendor: "", quantity: 2, name: "Custom Tee", custom: true, price: "20.00")], order_id: "13243585", shipping_line: nil, tags: "", total_price: "31.80", customer: customer)))
        productstableview.dataSource = self
        productstableview.delegate = self
        
        productstableview.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        
        viewMode.createCartDraftOrder()
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
