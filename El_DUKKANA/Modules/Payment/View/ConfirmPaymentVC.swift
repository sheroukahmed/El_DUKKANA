//
//  ConfirmPaymentVC.swift
//  El_DUKKANA
//
//  Created by ios on 18/09/2024.
//

import UIKit

class ConfirmPaymentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func continueShoppingBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let home = storyboard.instantiateViewController(identifier: "tabBar") as! UITabBarController
 
        home.modalPresentationStyle = .fullScreen
        home.modalTransitionStyle = .crossDissolve
        present(home, animated: true)
    }


}
