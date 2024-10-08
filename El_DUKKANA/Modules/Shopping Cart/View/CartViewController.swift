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
 
    var productIds : [Int] = []
 
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var noteLbl: UILabel!
    
    @IBOutlet weak var tpLbl: UILabel!
    var dummyImage = "https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square-600x600.webp"
    
    var productVm : ProductDetailsViewModel?
    var cartVM: CartViewModel?
    var favViewModel = FavoritesViewModel()
    var disposeBag = DisposeBag()
    
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
        productstableview.dataSource = self
        productstableview.delegate = self
        productstableview.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        
        cartVM = CartViewModel()
        productVm = ProductDetailsViewModel()
        
        cartVM?.bindResultToViewController = {
            self.indicator?.stopAnimating()
            self.updateTotalPrice()
            self.productstableview.reloadData()
            self.checkIfCartIsEmpty()
        }
        checkIfCartIsEmpty()
        
        for item in CurrentCustomer.currentCartDraftOrder.draft_order.line_items{
            productIds.append(item.product_id ?? 0)
        }
        let commaSeparatedString = productIds.map { String($0) }.joined(separator: ",")
        cartVM?.getproductImage(ids: commaSeparatedString)
        cartVM?.bindResultToViewController2 = {
            self.productstableview.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartVM?.getCartDraftFromApi()
        checkIfCartIsEmpty()
    }
    
    
    func updateTotalPrice() {
        if let priceString = CurrentCustomer.currentCartDraftOrder.draft_order.total_price, let price = Double(priceString) {
            let convertedPrice = price * CurrencyManager.shared.currencyRate
            totalprice.text = "\(convertedPrice)"
        }
        currency.text = CurrencyManager.shared.selectedCurrency
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
        if let priceString = lineItem.price, let price = Double(priceString) {
            let convertedPrice = price * CurrencyManager.shared.currencyRate
            cell.itemprice.text = "\(convertedPrice)"
        }
        cell.itemCurrency.text = CurrencyManager.shared.selectedCurrency
        cell.itemQuantity.text = String(lineItem.quantity ?? 1)
        
        if let availableQ = cartVM?.Quantity, indexPath.row < availableQ.count {
            let quantity = availableQ[indexPath.row]
            print("Image for product at row \(indexPath.row): \(quantity)")
            cell.availableQuantity.text = "\(quantity)"
        } else {
            
            cell.availableQuantity.text = "1000"
            print("Using dummy image for product at row \(indexPath.row)")
        }
        
        if let images = cartVM?.Images, indexPath.row < images.count {
            let imageUrl = images[indexPath.row]
            print("Image for product at row \(indexPath.row): \(imageUrl)")
            cell.itemimg.kf.setImage(with: URL(string: imageUrl))
        } else {
            
            cell.itemimg.kf.setImage(with: URL(string: dummyImage))
            print("Using dummy image for product at row \(indexPath.row)")
        }
        let variantDetails = lineItem.variant_title?.split(separator: "/")
        if variantDetails?.count == 2 {
            let size = variantDetails?[0].trimmingCharacters(in: .whitespaces)
            let color = variantDetails?[1].trimmingCharacters(in: .whitespaces)
                cell.itemSize.text = size
                cell.itemColor.text = color
            } else {
               
                cell.itemSize.text = "N/A"
                cell.itemColor.text = "N/A"
            }
        
        
        
        
        if let availableQuantity = cartVM?.Quantity, indexPath.row < availableQuantity.count {
            let quantity = availableQuantity[indexPath.row]
        
            let currentQuantity = lineItem.quantity ?? 1
        
        cell.increaseButton.isEnabled = currentQuantity < (quantity)/2
        cell.decreaseButton.isEnabled = currentQuantity > 1
        } else {
            let quantity = 5
        }
    
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
        
        indicator?.startAnimating()
 
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
       
       indicator?.startAnimating()
 
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
 
        let storyboard = UIStoryboard(name: "CheckoutPaymentStoryboard", bundle: nil)
        let Checkout = storyboard.instantiateViewController(identifier: "Checkout") as CheckoutViewController
        Checkout.title = "CheckOut"
        self.navigationController?.pushViewController(Checkout, animated: true)
 
    }
    
    func checkIfCartIsEmpty() {
        let isEmpty = CurrentCustomer.currentCartDraftOrder.draft_order.line_items.isEmpty
        
        productstableview.isHidden = isEmpty
        Checkoutbtn.isHidden = isEmpty
        emptyimage.isHidden = !isEmpty
    }
    
}
 
