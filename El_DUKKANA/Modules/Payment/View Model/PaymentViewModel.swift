//
//  PaymentViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 12/09/2024.
//

import Foundation
import PassKit

class paymentViewModel {

    var merchantID: String
    var supportedNetworks: [PKPaymentNetwork]
    var supportedCountries : Set<String>
    var countryCode: String
    var currencyCode: String
    var totalPrice: NSDecimalNumber = 0.0
    var selectedAdress : CustomerAddress?

    var paymentStatusUpdate: ((PKPaymentAuthorizationResult) -> Void)?
    
    
    init(merchantID: String, supportedNetworks: [PKPaymentNetwork], supportedCountries: Set<String>, countryCode: String, currencyCode: String, paymentStatusUpdate: ( (PKPaymentAuthorizationResult) -> Void)? = nil) {
        self.merchantID = merchantID
        self.supportedNetworks = supportedNetworks
        self.supportedCountries = supportedCountries
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.paymentStatusUpdate = paymentStatusUpdate
    }
    
    
    func createPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantID
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.supportedCountries = supportedCountries
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = countryCode
        paymentRequest.currencyCode = currencyCode
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Total", amount: totalPrice),
            PKPaymentSummaryItem(label: "Final Total", amount: totalPrice)
        ]
        
        return paymentRequest
    }
    

    func handlePaymentAuthorization(controller: PKPaymentAuthorizationViewController, payment: PKPayment, completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    
        let paymentResult = PKPaymentAuthorizationResult(status: .success, errors: nil)
        
        completion(paymentResult)
        
        paymentStatusUpdate?(paymentResult)
    }

    
    
    
    
}
