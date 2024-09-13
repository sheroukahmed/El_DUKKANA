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
    var totalPrice: NSDecimalNumber
    var discountPrice: NSDecimalNumber
    
    var paymentStatusUpdate: ((PKPaymentAuthorizationResult) -> Void)?
    
    init(merchantID: String, supportedNetworks: [PKPaymentNetwork], supportedCountries: Set<String>, countryCode: String, currencyCode: String, totalPrice: NSDecimalNumber, discountPrice: NSDecimalNumber, paymentStatusUpdate: ( (PKPaymentAuthorizationResult) -> Void)? = nil) {
        self.merchantID = merchantID
        self.supportedNetworks = supportedNetworks
        self.supportedCountries = supportedCountries
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.totalPrice = totalPrice
        self.discountPrice = discountPrice
        self.paymentStatusUpdate = paymentStatusUpdate
    }
    
    func calculateFinalPrice() -> NSDecimalNumber {
        return totalPrice.subtracting(discountPrice)
    }
    
    func createPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantID
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.supportedCountries = supportedCountries
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = countryCode
        paymentRequest.currencyCode = currencyCode
        
        let finalPrice = calculateFinalPrice()
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Total", amount: totalPrice),
            PKPaymentSummaryItem(label: "Discount", amount: discountPrice),
            PKPaymentSummaryItem(label: "Final Total", amount: finalPrice)
        ]
        
        return paymentRequest
    }
    

    func handlePaymentAuthorization(controller: PKPaymentAuthorizationViewController, payment: PKPayment, completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    
        let paymentResult = PKPaymentAuthorizationResult(status: .success, errors: nil)
        
        completion(paymentResult)
        
        paymentStatusUpdate?(paymentResult)
    }

    
    
    
    
}
