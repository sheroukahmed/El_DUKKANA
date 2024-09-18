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
    
    var checkoutVM = CheckoutViewModel()
    
    var customerVM = CustomerViewModel()
    
    

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
                let dr = CurrentCustomer.currentCartDraftOrder.draft_order
                let shippingAddress = self?.paymentVM!.selectedAdress
                let totalPrice = self?.paymentVM!.totalPrice
                let newDraft = DraftOrderRequest(draft_order:DraftOrder(id: dr.id, note: dr.note, email: dr.email, currency: dr.currency, created_at: dr.created_at, updated_at: dr.updated_at, completed_at: dr.completed_at, name: dr.name, status: dr.status, line_items: dr.line_items, order_id: dr.order_id, shipping_line: dr.shipping_line, tags: dr.tags, total_price: ("\(totalPrice)"), customer: dr.customer,shipping_address: shippingAddress))
                CurrentCustomer.currentCartDraftOrder = newDraft
                self?.checkoutVM.draftOrderCompleted()
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
        
      
        let dr = CurrentCustomer.currentCartDraftOrder.draft_order
        let shippingAddress = paymentVM!.selectedAdress
        let totalPrice = paymentVM!.totalPrice
        let newDraft = DraftOrderRequest(draft_order:DraftOrder(id: dr.id, note: dr.note, email: dr.email, currency: dr.currency, created_at: dr.created_at, updated_at: dr.updated_at, completed_at: dr.completed_at, name: dr.name, status: dr.status, line_items: dr.line_items, order_id: dr.order_id, shipping_line: dr.shipping_line, tags: dr.tags, total_price: ("\(totalPrice)"), customer: dr.customer,shipping_address: shippingAddress))
        CurrentCustomer.currentCartDraftOrder = newDraft
        
        self.checkoutVM.draftOrderCompleted()
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(3)) {
            self.checkoutVM.DeleteDraft()
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(3)) {
            self.customerVM.prepareCartDraftOrders()
            self.customerVM.addCarDraft()
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(3)) {
            self.customerVM.getAllDrafts()
        }
        
        
    }
}
