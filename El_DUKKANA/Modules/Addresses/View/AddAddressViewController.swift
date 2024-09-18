//
//  AddAddressViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 14/09/2024.
//

import UIKit
import Alamofire

class AddAddressViewController: UIViewController {

    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    @IBOutlet weak var saveAddressButton: UIButton!
    var viewModel = AddressesViewModel()
    var delegate : AddressDelegateProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        saveAddressButton.layer.cornerRadius = 15

    }
    

    @IBAction func saveAddress(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            CurrentCustomer.customerAddress.customer_address = CustomerAddress(address1: address1Txt.text ?? "", address2: address2Txt.text ?? "", city: cityTxt.text ?? "", country: countryTxt.text ?? "", zip: zipTxt.text ?? "")
            
            viewModel.addNewAddress()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(3)) {
                self.delegate?.didAddAddress()
            }
        }else{
            UIAlertController.showNoConnectionAlert(self: self)
        }
        
        
        
    }
}
