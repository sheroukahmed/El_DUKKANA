//
//  AddAddressViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 14/09/2024.
//

import UIKit

class AddAddressViewController: UIViewController {

    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    @IBOutlet weak var saveAddressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveAddressButton.layer.cornerRadius = 15

    }
    

    @IBAction func saveAddress(_ sender: Any) {
        
    }
}
