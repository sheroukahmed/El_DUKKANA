//
//  PaymentViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 15/09/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController , PKPaymentAuthorizationViewControllerDelegate{
    
    var paymentVM: paymentViewModel?
    
    var checkoutVM : CheckoutViewModel?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color 1")
        
        

        
        paymentVM?.paymentStatusUpdate = { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handlePaymentResult(result: result)
            }
        }
        
        
        
        
    }

    @IBAction func ApplePayBtn(_ sender: Any) {
        
        initiatePayment()
        
    }
    
    func initiatePayment() {
        let paymentRequest = (paymentVM?.createPaymentRequest())!
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentVM!.supportedNetworks) {
            if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                paymentVC.delegate = self
                present(paymentVC, animated: true, completion: nil)
            } else {
                print("Unable to present Apple Pay authorization view controller.")
            }
        } else {
            print("Apple Pay is not available on this device.")
        }
    }
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        paymentVM!.handlePaymentAuthorization(controller: controller, payment: payment, completion: completion)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {

        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func handlePaymentResult(result: PKPaymentAuthorizationResult) {
        switch result.status {
        case .success:
            let alert = UIAlertController(title: "Payment Successful", message: "Your payment was processed successfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){ [weak self] _ in
                self?.checkoutVM?.draftOrderCompleted()
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        case .failure:
            let alert = UIAlertController(title: "Payment Failed", message: "There was a problem processing your payment.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    @IBAction func CashBtn(_ sender: Any) {
        self.checkoutVM?.draftOrderCompleted()
        
    }
}
