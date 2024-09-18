//
//  CheckoutViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 12/09/2024.
//

import UIKit
import PassKit
import Alamofire

class CheckoutViewController: UIViewController, AddressSelectionDelegate {
    
    @IBOutlet weak var Address1: UILabel!
    @IBOutlet weak var Address2: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var ZipCode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var codetextF: UITextField!
    @IBOutlet weak var TotalPrice: UILabel!
    @IBOutlet weak var priceDiscount: UILabel!
    

    var paymentVM : paymentViewModel?
    
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
        checkoutVM?.getAllAddresses()
        checkoutVM?.bindToAddresses = {[weak self] in
            if !CurrentCustomer.customerAdresses.addresses.isEmpty && self?.paymentVM?.selectedAdress == nil{
                
                self?.Address1.text = CurrentCustomer.customerAdresses.addresses[0].address1
                self?.Address2.text = CurrentCustomer.customerAdresses.addresses[0].address2
                self?.city.text = CurrentCustomer.customerAdresses.addresses[0].city
                self?.ZipCode.text = CurrentCustomer.customerAdresses.addresses[0].zip
                self?.country.text = CurrentCustomer.customerAdresses.addresses[0].country
            }else if self?.paymentVM?.selectedAdress != nil{
                self?.Address1.text = self?.paymentVM?.selectedAdress?.address1
                self?.Address2.text = self?.paymentVM?.selectedAdress?.address2
                self?.city.text = self?.paymentVM?.selectedAdress?.city
                self?.ZipCode.text = self?.paymentVM?.selectedAdress?.zip
                self?.country.text = self?.paymentVM?.selectedAdress?.country
            }
            
            else {
                let alert = UIAlertController(title: "You have no addresses!", message: "you have to have address first.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default, handler: { action in
                    let storyboard = UIStoryboard(name: "AddressesStoryboard", bundle: nil)
                    if let addresses = storyboard.instantiateViewController(withIdentifier: "Addresses") as? AddressesViewController {
                        addresses.title = "My Addresses"
                        self?.navigationController?.pushViewController(addresses, animated: true)
                    }
                })
                alert.addAction(ok)
                self?.present(alert, animated: true)
                
            }}
        checkoutVM?.bindResultToViewController = { [weak self] in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.TotalPrice.text = self.checkoutVM?.checkoutDraft?.total_price
                self.priceDiscount.text = self.checkoutVM?.checkoutDraft?.total_price
            }
        }
        
    }
    
    @IBAction func SelectAddressbtn(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyboard = UIStoryboard(name: "AddressesStoryboard", bundle: nil)
            if let addresses = storyboard.instantiateViewController(withIdentifier: "Addresses") as? AddressesViewController {
                addresses.title = "My Addresses"
                addresses.delegate = self  // Set the delegate here
                self.navigationController?.pushViewController(addresses, animated: true)
            }
        } else {
            UIAlertController.showNoConnectionAlert(self: self)
        }

      
    }
    
    
    
    func didSelectAddress(address: CustomerAddress) {
            // Update the UI with the selected address
            Address1.text = address.address1
            Address2.text = address.address2
            city.text = address.city
            ZipCode.text = address.zip
            country.text = address.country
            
            paymentVM?.selectedAdress = address
        }
    
    @IBAction func ApplyCodebtn(_ sender: Any) {

        if NetworkReachabilityManager()?.isReachable ?? false {
            let priceafterdisc = checkoutVM?.calculatePriceWithDiscount(enteredcode: codetextF.text ?? "", totalPriceString: checkoutVM?.checkoutDraft?.total_price ?? "")
            priceDiscount.text = "\(priceafterdisc!)"
        }else{
            UIAlertController.showNoConnectionAlert(self: self)
        }
        
    }
    
    
    @IBAction func Paymentbtn(_ sender: Any) {

        
        paymentVM?.totalPrice = NSDecimalNumber(string: priceDiscount.text)
          
        let payscreen = self.storyboard?.instantiateViewController(withIdentifier: "pay") as! PaymentViewController
        payscreen.paymentVM = paymentVM
        payscreen.modalTransitionStyle = .crossDissolve
        payscreen.modalPresentationStyle = .fullScreen
        present(payscreen, animated: true)
        
    }
    
    
    
    
    
    
}
