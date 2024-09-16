//
//  UIAlertExtension.swift
//  El_DUKKANA
//
//  Created by Sarah on 16/09/2024.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func showNoConnectionAlert(self: UIViewController) {
        let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    static func showGuestAlert(self: UIViewController) {
        let alert = UIAlertController(title: "Guest Mode", message: "Please Login to enjoy our app", preferredStyle: .alert)
        let signIn = UIAlertAction(title: "Login", style: .default) { action in
            let storyBoard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        let cancle = UIAlertAction(title: "Cancle", style: .cancel)
        alert.addAction(signIn)
        alert.addAction(cancle)
        
        self.present(alert, animated: true)
    }
    
    static func showDiscountAlert(self: UIViewController) {
        let alert = UIAlertController(title: "Copied!", message: "Discount code has been copied to clipboard.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
