//
//  SignUpVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var signUpUsingGoogleBtn: UIButton!
    @IBOutlet weak var signUpWithGoogoleView: UIView!
    @IBOutlet weak var registerBtn: UIButton!{
        didSet{
            ViewsSet.btnSet(btn: registerBtn)
        }
    }
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    var viewModel = CustomerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.customer = Customer(id: 7828790968558, email: "samir7.sherouk@gmail.com", first_name: "sara", last_name: "And sherouk", phone: "+201165015450", verified_email: true, addresses: [CustomerAddress(address1: "sherouk", address2: "Lastnameson", city: "Ottawa", province: "Ontario", country: "Canada", zip: "123 ABC")], password: "123abc", password_confirmation: "123abc")
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func registerBtnAction(_ sender: Any) {
        viewModel.customer.first_name = firstNameTF.text
        viewModel.customer.last_name = lastNameTF.text
        viewModel.customer.email = emailTF.text
        viewModel.customer.password = passwordTF.text
        viewModel.customer.password_confirmation = confirmPassTF.text
        print(viewModel.customer.email)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp2VC") as? SignUp2VC{
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
    }
    @IBAction func signUpWithGoogleBtn(_ sender: Any) {
    }
   
}

