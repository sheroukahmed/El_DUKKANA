//
//  CartViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit


class CartViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var emptyimage: UIView!
    @IBOutlet weak var productstableview: UITableView!
    
    var cartVM : CartViewModel?
    var customerViewModel = CustomerViewModel()
    
    @IBOutlet weak var Checkoutbtn: UIButton!
    @IBOutlet weak var totalprice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productstableview.dataSource = self
        productstableview.delegate = self
        
        productstableview.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        
        cartVM = CartViewModel()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customerViewModel.getAllDrafts()        
        cartVM?.bindResultToViewController = {
            if (CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count) > 0 {
                self.Checkoutbtn.isEnabled = true
            }
            
            if CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count == 0{
                self.productstableview.isHidden = true
                self.emptyimage.isHidden = false
            }
            else {
                self.productstableview.isHidden = false
                self.emptyimage.isHidden = true
                self.updateTotalPrice()
            }
            
            
            self.productstableview.reloadData()
            self.updateTotalPrice()
        }
        
    
        
    }
    func updateTotalPrice() {
            let total = cartVM?.calculateTotalPrice() ?? 0.0
            totalprice.text = "Total: \(total)$"
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell
//        cell.itemimg.kf.setImage(with: URL(string: (cartVM?.cart?[indexPath.row].[0].value)!))
        cell.itemname.text = CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row].name
        
        cell.increaseButton.addTarget(self, action: #selector(increaseAction), for: .touchUpInside)
        cell.decreaseButton.addTarget(self, action: #selector(decreaseAction), for: .touchUpInside)
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Confirm Delete", message: "Do you want to delete this product from cart?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                CurrentCustomer.currentCartDraftOrder.draft_order.line_items.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
            
                if (CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count) == 0 {
                    self.Checkoutbtn.isEnabled = false
                }
                self.updateTotalPrice()
            }
            let no = UIAlertAction(title: "No", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true)
        }
    }
    
    @objc func increaseAction(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: productstableview)
        guard let indexPath = productstableview.indexPathForRow(at: point) else {return}
        CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row].quantity! += 1
        
        updateTotalPrice()
    }
    @objc func decreaseAction(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: productstableview)
        guard let indexPath = productstableview.indexPathForRow(at: point) else {return}
        CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row].quantity! -= 1
        
        updateTotalPrice()
    }
    
    
    @IBAction func gotocheckout(_ sender: Any) {
        
    }
    
}
