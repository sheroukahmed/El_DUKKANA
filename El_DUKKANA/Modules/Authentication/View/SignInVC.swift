//
//  SignInVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!{didSet{
        ViewsSet.btnSet(btn: loginBtn)
    }}
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    var customerViewModel = CustomerViewModel()
    
    
    var isFromSignOut = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFromSignOut {
            backBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        if CurrentCustomer.currentCustomer.email != nil {
            CurrentCustomer.currentCustomer.email = nil
        }
            
        guard let password = passwordTF.text, let email = emailTF.text else {
                showErrorAlert(message: "Please fill in both fields.")
                return
            }
            
            if email.isEmpty || password.isEmpty {
                showErrorAlert(message: "Email and password cannot be empty.")
                
            }  else {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    
                if let error = error {
                    self.showErrorAlert(message: "Invalid Email/Password")
                } else if let user = Auth.auth().currentUser, !user.isEmailVerified {
                    self.showErrorAlert(message: "Please verify your email before logging in.")
                    try? Auth.auth().signOut() // Sign out unverified users
                } else {
                    self.showAccountSignedInAlert()
                    self.customerViewModel.customeremail = email
                    self.customerViewModel.getAllCustomer()
                    
                    
                }
            }
        }
    }
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        guard let email = emailTF.text else {
                showErrorAlert(message: "Please enter a valid email to reset the password.")
                return
            }

            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    let alert = UIAlertController(title: "Password Reset", message: "A password reset link has been sent to your email.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }

    func showAccountSignedInAlert() {
        let alert = UIAlertController(title: "Account Signed in!", message: "The account has been Signed in successfully", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
            let home = storyboard.instantiateViewController(identifier: "tabBar") as! UITabBarController
            home.modalPresentationStyle = .fullScreen
            home.modalTransitionStyle = .crossDissolve
            self.present(home, animated: true)
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
