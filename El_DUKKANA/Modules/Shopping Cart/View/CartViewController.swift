//
//  CartViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//


import UIKit
import RxSwift
import RxCocoa
import Alamofire

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyimage: UIView!
    @IBOutlet weak var productstableview: UITableView!
    @IBOutlet weak var Checkoutbtn: UIButton!
    @IBOutlet weak var totalprice: UILabel!
    
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    var productVm : ProductDetailsViewModel?
    var cartVM: CartViewModel?
    var favViewModel = FavoritesViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productstableview.dataSource = self
        productstableview.delegate = self
        productstableview.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        
        cartVM = CartViewModel()
        productVm = ProductDetailsViewModel()
        
        cartVM?.bindResultToViewController = {
            self.updateTotalPrice()
            self.productstableview.reloadData()
            self.checkIfCartIsEmpty()
        }
        checkIfCartIsEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartVM?.getCartDraftFromApi()
        checkIfCartIsEmpty()
    }
    
    
    func updateTotalPrice() {
        totalprice.text = CurrentCustomer.currentCartDraftOrder.draft_order.total_price ?? "0.00"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell
        let lineItem = CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row]
        
        if let title = lineItem.title {
            let components = title.split(separator: " | ", maxSplits: 1)
            cell.itemname.text = components.count > 1 ? String(components[1]) : String(components[0])
        }
        cell.itemprice.text = lineItem.price
        cell.itemQuantity.text = String(lineItem.quantity ?? 1)
        cell.availableQuantity.text = "5"
        

    
        let availableQuantity = Int(cell.availableQuantity.text!) ?? 5
        let currentQuantity = lineItem.quantity ?? 1
        
        cell.increaseButton.isEnabled = currentQuantity < availableQuantity
        cell.decreaseButton.isEnabled = currentQuantity > 1
        
    
        cell.increaseButton.tag = indexPath.row
        cell.decreaseButton.tag = indexPath.row

        // Add actions for the buttons
        cell.increaseButton.addTarget(self, action: #selector(increaseAction(_:)), for: .touchUpInside)
        cell.decreaseButton.addTarget(self, action: #selector(decreaseAction(_:)), for: .touchUpInside)

        
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Confirm Delete", message: "Do you want to delete this product from cart?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                
                print(CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count)
                CurrentCustomer.currentCartDraftOrder.draft_order.line_items.remove(at: indexPath.row)
                                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)

                tableView.endUpdates()
                print(CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count)
                
                if (CurrentCustomer.currentCartDraftOrder.draft_order.line_items.count) == 0 {
                    self.Checkoutbtn.isEnabled = false
                }
                self.updateTotalPrice()
                self.productVm?.updateCartDraftOrder()
                
                self.checkIfCartIsEmpty()
                
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
                    self.cartVM?.getCartDraftFromApi()}}
            
            let no = UIAlertAction(title: "No", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true)
        }
    }
    
    @objc func increaseAction(_ sender: UIButton) {
       let indexPath = IndexPath(row: sender.tag, section: 0)
       var item = CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row]
       
       item.quantity! += 1
       CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row] = item
       
       cartVM?.quantityUpdateSubject.onNext(())
    
       productstableview.reloadRows(at: [indexPath], with: .automatic)
       productstableview.reloadData()
        
        checkIfCartIsEmpty()
   }

   @objc func decreaseAction(_ sender: UIButton) {
       let indexPath = IndexPath(row: sender.tag, section: 0)
       var item = CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row]
       
       if item.quantity! > 1 {
           item.quantity! -= 1
           CurrentCustomer.currentCartDraftOrder.draft_order.line_items[indexPath.row] = item
           
           cartVM?.quantityUpdateSubject.onNext(())
        
           productstableview.reloadRows(at: [indexPath], with: .automatic)
           productstableview.reloadData()
           
           checkIfCartIsEmpty()
       }
   }
    
    @IBAction func GotoCheckoutbtn(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyboard = UIStoryboard(name: "CheckoutPaymentStoryboard", bundle: nil)
            let Checkout = storyboard.instantiateViewController(identifier: "Checkout") as CheckoutViewController
            Checkout.title = "CheckOut"
            self.navigationController?.pushViewController(Checkout, animated: true)
        }
        UIAlertController.showNoConnectionAlert(self: self)
    }
    
    func checkIfCartIsEmpty() {
        let isEmpty = CurrentCustomer.currentCartDraftOrder.draft_order.line_items.isEmpty
        
        productstableview.isHidden = isEmpty
        Checkoutbtn.isHidden = isEmpty
        emptyimage.isHidden = !isEmpty
    }
    
}

