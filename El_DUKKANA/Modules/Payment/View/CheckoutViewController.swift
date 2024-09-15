//
//  CheckoutViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 12/09/2024.
//

import UIKit
import PassKit

class CheckoutViewController: UIViewController  {
    
    @IBOutlet weak var Address1: UILabel!
    
    @IBOutlet weak var Address2: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var ZipCode: UILabel!
    
    @IBOutlet weak var country: UILabel!
    
    
    @IBOutlet weak var codetextF: UITextField!
    
    @IBOutlet weak var TotalPrice: UILabel!
    
    @IBOutlet weak var priceDiscount: UILabel!
    
    var paymentVM :paymentViewModel?
    
    var checkoutVM : CheckoutViewModel?
    
    var paymenyprice :NSDecimalNumber?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Color 1")
        
        paymentVM = paymentViewModel(
            merchantID: "merchant.com.example",
            supportedNetworks: [.visa, .masterCard, .amex],
            supportedCountries: ["EG", "US"],
            countryCode: "EG",
            currencyCode: "EGP"
        )
        
        checkoutVM = CheckoutViewModel()
        checkoutVM?.getDraftOrder()
        checkoutVM?.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.TotalPrice.text = self.checkoutVM?.checkoutDraft?.total_price
                self.priceDiscount.text = self.checkoutVM?.checkoutDraft?.total_price
            }
        }
        
        
        
        
        
        
    }
    
    @IBAction func SelectAddressbtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddressesStoryboard", bundle: nil)
        if let addresses = storyboard.instantiateViewController(withIdentifier: "Addresses") as? AddressesViewController {
            addresses.title = "My Addresses"
            self.navigationController?.pushViewController(addresses, animated: true)
        }
        
    }
    
    @IBAction func ApplyCodebtn(_ sender: Any) {
        
        let priceafterdisc = checkoutVM?.calculatePriceWithDiscount(enteredcode: codetextF.text ?? "", totalPriceString: checkoutVM?.checkoutDraft?.total_price ?? "")
        priceDiscount.text = "\(priceafterdisc!)"
        
    }
    
    
    
    
    @IBAction func Paymentbtn(_ sender: Any) {
        
        paymentVM?.totalPrice = NSDecimalNumber(string: priceDiscount.text)
        
        let payscreen = self.storyboard?.instantiateViewController(withIdentifier: "pay") as! PaymentViewController
        payscreen.paymentVM = paymentVM
        present(payscreen, animated: true)
        
    }
    
    
    
    
    
    
}
