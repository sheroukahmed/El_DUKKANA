//
//  SignUpVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var signUpWithGoogoleView: UIView!
    @IBOutlet weak var registerBtn: UIButton!{
        didSet{
            ViewsSet.btnSet(btn: registerBtn)
        }
    }
    @IBOutlet weak var phoneNumberTF: UITextField!
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
        if validateInput() {
            // Proceed with Firebase Authentication
            guard let email =  CurrentCustomer.signedUpCustomer.customer.email,
                  let password = CurrentCustomer.signedUpCustomer.customer.password else {
                showErrorAlert()
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    // Firebase registration failed
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                } else {
                    // Firebase registration succeeded
//                    self.viewModel.addCustomer()
//                    self.showAccountCreatedAlert()
                    
                    
                    // Firebase registration succeeded, send email verification
                        self.sendVerificationEmail()
                   
                }
            }
        } else {
            showErrorAlert()
        }
    }
    
    @IBAction func signUpWithGoogleBtn(_ sender: Any) {
        // Google sign-up logic here
    }
    
    func validateInput() -> Bool {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let confirmPassword = confirmPassTF.text, !confirmPassword.isEmpty,
              let firstName = firstNameTF.text, !firstName.isEmpty,
              let lastName = lastNameTF.text, !lastName.isEmpty,
              let phone = phoneNumberTF.text, !phone.isEmpty else {
            return false
        }
        
        if password != confirmPassword {
            return false
        }
        
        
        // Validate if the email is a Gmail address
                if !isValidGmail(email: email) {
                    showErrorAlertWithMessage(message: "Please use a valid Gmail address")
                    return false
                }
        
        // Update ViewModel with input data
        CurrentCustomer.signedUpCustomer.customer.first_name = firstName
        CurrentCustomer.signedUpCustomer.customer.last_name = lastName
        CurrentCustomer.signedUpCustomer.customer.email = email
        CurrentCustomer.signedUpCustomer.customer.password = password
        CurrentCustomer.signedUpCustomer.customer.password_confirmation = confirmPassword
        CurrentCustomer.signedUpCustomer.customer.phone = phone
        
        
        return true
    }
    
    func sendVerificationEmail() {
            guard let user = Auth.auth().currentUser else { return }
            user.sendEmailVerification { [weak self] error in
                if let error = error {
                    self?.showErrorAlertWithMessage(message: "\(error)")
                } else {
                    self?.showVerificationAlert()
                    // Call the backend `addCustomer` function here
                    self?.viewModel.addCustomer()
                }
            }
        }
    
    // Function to validate if the email is a Gmail address
    
        func isValidGmail(email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@gmail.com"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    func showAccountCreatedAlert() {
        let alert = UIAlertController(title: "Account Created", message: "The account has been created successfully", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            let storyBoard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
                
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showVerificationAlert() {
            let alert = UIAlertController(title: "Email Verification Sent", message: "Please check your Gmail inbox and verify your email address before logging in.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { [weak self] action in
                self?.dismiss(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill all fields correctly", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    // Show an error alert with custom message
        func showErrorAlertWithMessage(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
}
