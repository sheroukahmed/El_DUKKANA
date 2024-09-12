//
//  SignUp2VC.swift
//  El_DUKKANA
//
//  Created by ios on 12/09/2024.
//

import UIKit

class SignUp2VC: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!{
        didSet{
            ViewsSet.btnSet(btn: registerBtn)
        }    }
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    let viewModel = CustomerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //==============================================
        
    }

    @IBAction func registerBtnAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Accoun Created", message: "the account has been created succefully", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default) { action in
            self.viewModel.customer.phone = self.phoneNumberTF.text
            self.viewModel.customer.addresses?[0].address1 = self.addressTF.text
            self.viewModel.customer.addresses?[0].city = self.cityTF.text
            self.viewModel.customer.addresses?[0].country = self.countryTF.text
            self.viewModel.customer.addresses?[0].zip = self.zipTF.text
            self.viewModel.customer.addresses?[0].address2 = "Lastnameson"
            self.viewModel.customerDraftFav = (DraftOrderRequest(draft_order: DraftOrder(id: 342523442, email: "\(self.viewModel.customer.email ?? "")", currency: "USD", created_at: "2024-9-4", updated_at: "2024-9-7", completed_at: "2024-9-9", name: "#D3", status: "open",line_items: [LineItem(id: 1066630381, variant_id: 45726370201838, product_id: 8649736323310, title: "ADIDAS | CLASSIC BACKPACK", variant_title: "OS / black", vendor: "ADIDAS", quantity: 1,name: "CONVERSE | CHUCK TAYLOR ALL STAR LO",custom: true, price: "70.00"),LineItem(id: 342523443, variant_id: 45726367351022, product_id: 8649735897326, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variant_title: "3 / white", vendor: "CONVERSE", quantity: 1,name: "CONVERSE | CHUCK TAYLOR ALL STAR LO",custom: true, price: "100.00"),LineItem(id: 342523444, variant_id: 45726360633582, product_id: 8649735241966, title: "ASICS TIGER | GEL-LYTE V '30 YEARS OF GEL' PACK", variant_title: "4 / black", vendor: "ASICS TIGER", quantity: 1,name: "CONVERSE | CHUCK TAYLOR ALL STAR LO",custom: true, price: "220.00")], order_id: "13243585", shipping_line: nil, tags: "", total_price: "31.80", customer: self.viewModel.customer)))
            //----------------------------------------------
            self.viewModel.customerDraftCart = (DraftOrderRequest(draft_order: DraftOrder(id: 342523442, email: "\(self.viewModel.customer.email ?? "")", currency: "USD", created_at: "2024-9-4", updated_at: "2024-9-7", completed_at: "2024-9-9", name: "#D3", status: "open",line_items: [LineItem(id: 1066630381, variant_id: 45726370201838, product_id: 8649736323310, title: "ADIDAS | CLASSIC BACKPACK", variant_title: "OS / black", vendor: "ADIDAS", quantity: 1,name: "CONVERSE | CHUCK TAYLOR ALL STAR LO",custom: true, price: "70.00"),LineItem(id: 342523443, variant_id: 45726367351022, product_id: 8649735897326, title: "CONVERSE | CHUCK TAYLOR ALL STAR LO", variant_title: "3 / white", vendor: "CONVERSE", quantity: 1,name: "CONVERSE | CHUCK TAYLOR ALL STAR LO",custom: true, price: "100.00"),LineItem(id: 342523444, variant_id: 45726360633582, product_id: 8649735241966, title: "ASICS TIGER | GEL-LYTE V '30 YEARS OF GEL' PACK", variant_title: "4 / black", vendor: "ASICS TIGER", quantity: 1,name: "CONVERSE | CHUCK TAYLOR ALL STAR LO",custom: true, price: "220.00")], order_id: "13243585", shipping_line: nil, tags: "", total_price: "31.80", customer: self.viewModel.customer)))
            print("\(self.viewModel.customer.phone) prinnnnnnntttt")
            self.viewModel.addCustomer()
        }
        let cancle = UIAlertAction(title: "Cancle", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancle)
        self.present(alert, animated: true)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func signUpWithGBtn(_ sender: Any) {
    }
}
