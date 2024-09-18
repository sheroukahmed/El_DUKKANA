//
//  SignUpVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var signUpWithGoogoleView: UIView!
    @IBOutlet weak var registerBtn: UIButton!{
        didSet{
            ViewsSet.btnSet(btn: registerBtn)
        }
    }
    @IBOutlet weak var showConfirmPassBtn: UIButton!
    @IBOutlet weak var showPassBtn: UIButton!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    var isVerified = false
    var verificationTimer: Timer? // Timer for checking verification status
    var isPasswordVisible = false
    var isConfirmPasswordVisible = false
        
    var viewModel = CustomerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        confirmPassTF.delegate = self
        passwordTF.isSecureTextEntry = true
        confirmPassTF.isSecureTextEntry = true
        setButtonPositionFor(passwordTF)
        setButtonPositionFor(confirmPassTF)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == passwordTF || textField == confirmPassTF {
                setButtonPositionFor(textField)
            }
            return true
        }
    func setButtonPositionFor(_ textField: UITextField) {
            guard let currentLanguage = textField.textInputMode?.primaryLanguage else { return }

            let isRightToLeft = Locale.characterDirection(forLanguage: currentLanguage) == .rightToLeft

            if textField == passwordTF {
                updateButtonPosition(button: showPassBtn, isRightToLeft: isRightToLeft)
            } else if textField == confirmPassTF {
                updateButtonPosition(button: showConfirmPassBtn, isRightToLeft: isRightToLeft)
            }
        }
    func updateButtonPosition(button: UIButton, isRightToLeft: Bool) {
            let buttonFrame = button.frame
            let textFieldFrame = button.superview?.frame ?? .zero
            let padding: CGFloat = 10

            if isRightToLeft {
                // Move button to the left for Arabic
                button.frame = CGRect(x: padding, y: buttonFrame.origin.y, width: buttonFrame.width, height: buttonFrame.height)
            } else {
                // Move button to the right for English
                button.frame = CGRect(x: textFieldFrame.width - 30 - buttonFrame.width - 30 - padding, y: buttonFrame.origin.y, width: buttonFrame.width, height: buttonFrame.height)
            }
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
    
    @IBAction func goToSignUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signInVC = storyboard.instantiateViewController(identifier: "SignInVC")
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.modalTransitionStyle = .crossDissolve
       present(signInVC, animated: true)
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
    
    @IBAction func showPassBtn(_ sender: Any) {
        isPasswordVisible.toggle()
        passwordTF.isSecureTextEntry = !isPasswordVisible
                
                // Optionally change the button title or image
        let buttonTitle = isPasswordVisible ? "Hide Password" : "Show Password"
        showPassBtn.setImage(UIImage(named: isPasswordVisible ? "eye" : "eye.fill"), for: .normal)
    }
    @IBAction func showConfirmPassBtn(_ sender: Any) {
        isConfirmPasswordVisible.toggle()
        confirmPassTF.isSecureTextEntry = !isConfirmPasswordVisible
                
        let buttonTitle = isConfirmPasswordVisible ? "Hide" : "Show"
        showConfirmPassBtn.setImage(UIImage(named: isPasswordVisible ? "eye" : "eye.fill"), for: .normal)
    }
    
    
    func sendVerificationEmail() {
        guard let user = Auth.auth().currentUser else { return }
        user.sendEmailVerification { [weak self] error in
            if let error = error {
                self?.showErrorAlertWithMessage(message: "\(error)")
            } else {
                self?.showVerificationAlert()
                // Call the backend `addCustomer` function here
                //self?.viewModel.addCustomer()
            }
        }
    }

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
    
    func startVerificationTimer(){
        verificationTimer?.invalidate() // Invalidate any existing timer
        verificationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkEmailVerification), userInfo: nil, repeats: true)
        
    }
    // Function to check if email is verified
    @objc func checkEmailVerification() {
        Auth.auth().currentUser?.reload(completion: { [weak self] error in
            guard let user = Auth.auth().currentUser, error == nil else {
                return
            }
     
            if user.isEmailVerified {
                // Email is verified, stop timer and add customer to backend
                self?.verificationTimer?.invalidate()
                self?.verificationTimer = nil
                // Add customer to backend
                self?.viewModel.addCustomer()
     
                // Show success alert and navigate to SignInVC
                self?.showAccountCreatedAlert()
            } else {
                // Show an alert to remind the user to verify their email
                self?.showVerificationReminderAlert()
            }
        })
    }
    
    func showVerificationAlert() {
            let alert = UIAlertController(title: "Email Verification Sent", message: "Please check your Gmail inbox and verify your email address before logging in.", preferredStyle: .alert)
     
            let ok = UIAlertAction(title: "OK", style: .default) { [weak self] action in
                // Start timer to check email verification every 5 seconds
                self?.startVerificationTimer()
            }
     
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    
    func showVerificationReminderAlert() {
        let alert = UIAlertController(
            title: "Email Verification Pending",
            message: "Please verify your email before proceeding.",
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Continue checking after the alert is dismissed
            self?.startVerificationTimer()
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
