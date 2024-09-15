//
//  CheckoutViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 12/09/2024.
//

import UIKit
import PassKit
import Alamofire

class CheckoutViewController: UIViewController , PKPaymentAuthorizationViewControllerDelegate {
    
    @IBOutlet weak var Address1: UILabel!
    @IBOutlet weak var Address2: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var ZipCode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var codetextF: UITextField!
    @IBOutlet weak var TotalPrice: UILabel!
    @IBOutlet weak var priceDiscount: UILabel!
    
    var paymentVM: paymentViewModel?
    var checkoutVM : CheckoutViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Color 1")
        checkoutVM = CheckoutViewModel()
        checkoutVM?.getDraftOrder()
        checkoutVM?.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.TotalPrice.text = self.checkoutVM?.checkoutDraft?.total_price
                self.priceDiscount.text = self.checkoutVM?.checkoutDraft?.total_price
            }
        }
        
        paymentVM = paymentViewModel(
            merchantID: "merchant.com.example",
            supportedNetworks: [.visa, .masterCard, .amex],
            supportedCountries: ["EG", "US"],
            countryCode: "EG",
            currencyCode: "USD"
        )
        paymentVM?.paymentStatusUpdate = { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handlePaymentResult(result: result)
            }
        }
    }
    
    @IBAction func SelectAddressbtn(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let storyboard = UIStoryboard(name: "AddressesStoryboard", bundle: nil)
            if let addresses = storyboard.instantiateViewController(withIdentifier: "Addresses") as? AddressesViewController {
                addresses.title = "My Addresses"
                self.navigationController?.pushViewController(addresses, animated: true)
            } }
        UIAlertController.showNoConnectionAlert(self: self)
    }
    
    @IBAction func ApplyCodebtn(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            var priceafterdisc = checkoutVM?.calculatePriceWithDiscount(enteredcode: codetextF.text ?? "", totalPriceString: checkoutVM?.checkoutDraft?.total_price ?? "")
            priceDiscount.text = "\(priceafterdisc!)"
        }
        UIAlertController.showNoConnectionAlert(self: self)
    }
    
    
    @IBAction func Paymentbtn(_ sender: Any) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            paymentVM?.totalPrice = NSDecimalNumber(string: priceDiscount.text)
            initiatePayment()
        }
        UIAlertController.showNoConnectionAlert(self: self)
    }
    
    func initiatePayment() {
        let paymentRequest = paymentVM!.createPaymentRequest()
        
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
    
    
    
}
