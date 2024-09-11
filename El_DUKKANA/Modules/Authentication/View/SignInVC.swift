//
//  SignInVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!{didSet{
        ViewsSet.btnSet(btn: loginBtn)
    }}
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        
    }
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
    }
    
    

}
