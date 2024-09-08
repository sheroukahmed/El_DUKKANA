//
//  SignUpVC.swift
//  El_Dukkana
//
//  Created by ios on 03/09/2024.
//

import UIKit

class SignUpVC: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func registerBtnAction(_ sender: Any) {
    }
    @IBAction func signUpWithGoogleBtn(_ sender: Any) {
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
