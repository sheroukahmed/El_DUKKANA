//
//  ProductDetailsVC.swift
//  El_DUKKANA
//
//  Created by ios on 06/09/2024.
//

import UIKit

class ProductDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showReviewsBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ReviewsViewController") as? ReviewsViewController
        if let viewController = vc {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
            
        }
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
