//
//  SignInVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!{didSet{
        ViewsSet.btnSet(btn: loginBtn)
    }}
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var hideShowPassBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    var customerViewModel = CustomerViewModel()
    var isPasswordVisible = false

    
    var isFromSignOut = false
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        if isFromSignOut {
            backBtn.isHidden = true
        }
        setButtonPositionFor(passwordTF)
        passwordTF.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == passwordTF {
                setButtonPositionFor(textField)
            }
            return true
        }
    func setButtonPositionFor(_ textField: UITextField) {
            guard let currentLanguage = textField.textInputMode?.primaryLanguage else { return }

            let isRightToLeft = Locale.characterDirection(forLanguage: currentLanguage) == .rightToLeft

            if textField == passwordTF {
                updateButtonPosition(button: hideShowPassBtn, isRightToLeft: isRightToLeft)
            
            }}
    func updateButtonPosition(button: UIButton, isRightToLeft: Bool) {
            let buttonFrame = button.frame
            let textFieldFrame = button.superview?.frame ?? .zero
            let padding: CGFloat = 10

            if isRightToLeft {
                // Move button to the left for Arabic
                button.frame = CGRect(x: padding, y: buttonFrame.origin.y, width: buttonFrame.width, height: buttonFrame.height)
            } else {
                // Move button to the right for English
                button.frame = CGRect(x: textFieldFrame.width  - buttonFrame.width - padding, y: buttonFrame.origin.y, width: buttonFrame.width, height: buttonFrame.height)
            }
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
    
    @IBAction func hideAndShowPassBtn(_ sender: Any) {
        isPasswordVisible.toggle()
        passwordTF.isSecureTextEntry = !isPasswordVisible
        let buttonTitle = isPasswordVisible ? "Hide" : "Show"
//        hideShowPassBtn.setTitle(buttonTitle, for: .normal)
        hideShowPassBtn.setImage(UIImage(named: isPasswordVisible ? "eye" : "eye.fill"), for: .normal)
    }
    @IBAction func goToSignUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(identifier: "SignUpVC")
        signUpVC.modalPresentationStyle = .fullScreen
        signUpVC.modalTransitionStyle = .crossDissolve
        present(signUpVC, animated: true)
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
