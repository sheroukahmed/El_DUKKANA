//
//  PaymentViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 15/09/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    var paymentVM: paymentViewModel?

    var checkoutVM = CheckoutViewModel()
    var customerVM = CustomerViewModel()
    var productVm = ProductDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color 1")
        
        paymentVM?.paymentStatusUpdate = { [weak self] result in
            print("Payment status update received: \(result.status)")
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
        guard let paymentRequest = paymentVM?.createPaymentRequest() else {
            print("Failed to create payment request")
            return
        }
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentVM?.supportedNetworks ?? []) {
            if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                paymentVC.delegate = self
                present(paymentVC, animated: true) {
                    print("Apple Pay authorization view controller presented")
                }
            } else {
                print("Unable to present Apple Pay authorization view controller.")
            }
        } else {
            print("Apple Pay is not available on this device.")
        }
    }

    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("Did authorize payment")
        paymentVM?.handlePaymentAuthorization(controller: controller, payment: payment, completion: completion)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("Payment Authorization View Controller Did Finish")
        controller.dismiss(animated: true) {
            print("Apple Pay authorization view controller dismissed")
        }
    }
    
    func handlePaymentResult(result: PKPaymentAuthorizationResult) {
        print("Handling payment result: \(result.status)")
        switch result.status {
        case .success:
            print("Payment successful")
            showAlert(title: "Payment Successful", message: "Your payment was processed successfully.") {
                self.handleSuccessfulPayment()
            }
        case .failure:
            print("Payment failed")
            showAlert(title: "Payment Failed", message: "There was a problem processing your payment.")
        default:
            break
        }
    }
    
    func handleSuccessfulPayment() {
        let dr = CurrentCustomer.currentCartDraftOrder.draft_order
        let shippingAddress = paymentVM?.selectedAdress
        let totalPrice = paymentVM?.totalPrice
        
        checkoutVM.orderToPost = OrderRequest(order: Order(id: dr.id, email: dr.email, created_at: dr.created_at, currency: dr.currency, name: dr.name, line_items: dr.line_items, total_price: "\(totalPrice ?? 0)", customer: dr.customer, shipping_address: shippingAddress))
        
        checkoutVM.postNewOrder()
        
        let newDraft = DraftOrderRequest(draft_order: DraftOrder(id: dr.id, note: dr.note, email: dr.email, currency: dr.currency, created_at: dr.created_at, updated_at: dr.updated_at, completed_at: dr.completed_at, name: dr.name, status: dr.status, line_items: [LineItem(id: 8649735831790, variant_id: 45726370201838, product_id: 8649736323310, title: "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH", variant_title: "4 / red", vendor: "DR MARTENS", quantity: 1, name: "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH", custom: true, price: "100000.00", properties: [])], order_id: dr.order_id, shipping_line: dr.shipping_line, tags: dr.tags, total_price: "", customer: dr.customer))
        
        CurrentCustomer.currentCartDraftOrder = newDraft
        productVm.updateCartDraftOrder()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ConfirmPaymentVC")as? ConfirmPaymentVC{
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @IBAction func CashBtn(_ sender: Any) {
        handleSuccessfulPayment()
    }
}






//import UIKit
//import PassKit
//
//class PaymentViewController: UIViewController , PKPaymentAuthorizationViewControllerDelegate{
//
//    var paymentVM: paymentViewModel?
//
//    var checkoutVM = CheckoutViewModel()
//
//    var customerVM = CustomerViewModel()
//
//    var productVm = ProductDetailsViewModel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(named: "Color 1")
//
//        paymentVM?.paymentStatusUpdate = { [weak self] result in
//            print("Payment status update received: \(result.status)")
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.handlePaymentResult(result: result)
//            }
//        }
//    }
//
//    @IBAction func ApplePayBtn(_ sender: Any) {
//
//        initiatePayment()
//
//    }
//
//    func initiatePayment() {
//        guard let paymentRequest = paymentVM?.createPaymentRequest() else {
//            print("Failed to create payment request")
//            return
//        }
//
//        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentVM?.supportedNetworks ?? []) {
//            if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
//                paymentVC.delegate = self
//                present(paymentVC, animated: true, completion: nil)
//            } else {
//                print("Unable to present Apple Pay authorization view controller.")
//            }
//        } else {
//            print("Apple Pay is not available on this device.")
//        }
//    }
//
//    // MARK: - PKPaymentAuthorizationViewControllerDelegate
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        print("Did authorize payment")
//        paymentVM?.handlePaymentAuthorization(controller: controller, payment: payment, completion: completion)
//    }
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        print("Payment Authorization View Controller Did Finish")
//        controller.dismiss(animated: true, completion: nil)
//    }
//
//    func handlePaymentResult(result: PKPaymentAuthorizationResult) {
//        print("Handling payment result: \(result.status)")
//        switch result.status {
//        case .success:
//            let alert = UIAlertController(title: "Payment Successful", message: "Your payment was processed successfully.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default){ [weak self] _ in
//                let dr = CurrentCustomer.currentCartDraftOrder.draft_order
//                let shippingAddress = self?.paymentVM?.selectedAdress
//                let totalPrice = self?.paymentVM?.totalPrice
//
//                self?.checkoutVM.orderToPost = OrderRequest(order: Order(id: dr.id, email: dr.email, created_at: dr.created_at, currency: dr.currency, name: dr.name, tags: dr.tags, line_items: dr.line_items, total_price: "\(totalPrice)", customer: dr.customer, shipping_address: shippingAddress))
//
//                self?.checkoutVM.postNewOrder()
//
//                let newDraft = DraftOrderRequest(draft_order: DraftOrder(id: dr.id, note: dr.note, email: dr.email, currency: dr.currency, created_at: dr.created_at, updated_at: dr.updated_at, completed_at: dr.completed_at, name: dr.name, status: dr.status, line_items: [LineItem(id: 8649735831790, variant_id: 45726370201838, product_id: 8649736323310, title: "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH", variant_title: "4 / red", vendor: "DR MARTENS", quantity: 1, name: "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH", custom: true, price: "100000.00", properties: [])], order_id: dr.order_id, shipping_line: dr.shipping_line, tags: dr.tags, total_price: "", customer: dr.customer))
//
//                CurrentCustomer.currentCartDraftOrder = newDraft
//                self?.productVm.updateCartDraftOrder()
//            }
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//        case .failure:
//            let alert = UIAlertController(title: "Payment Failed", message: "There was a problem processing your payment.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default)
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//
//
//    @IBAction func CashBtn(_ sender: Any) {
//
//
//        let dr = CurrentCustomer.currentCartDraftOrder.draft_order
//        let shippingAddress = paymentVM!.selectedAdress
//        let totalPrice = paymentVM!.totalPrice
//
//
//
//        checkoutVM.orderToPost = OrderRequest(order:Order(id: dr.id, email: dr.email, created_at: dr.created_at, currency: dr.currency, name: dr.name, tags: dr.tags, line_items: dr.line_items, total_price: ("\(totalPrice)"), customer: dr.customer, shipping_address: shippingAddress))
//
//
//        checkoutVM.postNewOrder()
//
//
//        let newDraft = DraftOrderRequest(draft_order:DraftOrder(id: dr.id, note: dr.note, email: dr.email, currency: dr.currency, created_at: dr.created_at, updated_at: dr.updated_at, completed_at: dr.completed_at, name: dr.name, status: dr.status, line_items: [LineItem(id: 8649735831790, variant_id: 45726370201838, product_id: 8649736323310, title: "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH", variant_title: "4 / red", vendor: "DR MARTENS", quantity: 1, name: "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH", custom: true, price: "100000.00",properties: [])], order_id: dr.order_id, shipping_line: dr.shipping_line, tags: dr.tags, total_price: "", customer: dr.customer))
//
//        CurrentCustomer.currentCartDraftOrder = newDraft
//
//        productVm.updateCartDraftOrder()
//
//
//
//    }
//}
//
//
//
