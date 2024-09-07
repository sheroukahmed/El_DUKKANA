//
//  SignInVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
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
        let storyboard = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(identifier: "ProductDetailsVC")
        signUpVC.modalPresentationStyle = .fullScreen
        signUpVC.modalTransitionStyle = .crossDissolve
       present(signUpVC, animated: true)
    }
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
