//
//  StartOptionsVC.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 04/09/2024.
//

import UIKit

class StartOptionsVC: UIViewController {

    @IBOutlet weak var registerBt: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    @IBAction func asGuestBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "tabBar") as! UITabBarController
        home.modalPresentationStyle = .fullScreen
        home.modalTransitionStyle = .crossDissolve
       present(home, animated: true)
    }
    
    @IBAction func toSignUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(identifier: "SignUpVC")
        signUpVC.modalPresentationStyle = .fullScreen
        signUpVC.modalTransitionStyle = .crossDissolve
       present(signUpVC, animated: true)
        
    }
    @IBAction func toLoginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signInVC = storyboard.instantiateViewController(identifier: "SignInVC")
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.modalTransitionStyle = .crossDissolve
       present(signInVC, animated: true)
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
