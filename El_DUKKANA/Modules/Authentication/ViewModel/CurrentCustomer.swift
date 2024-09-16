//
//  CurrentCustomer.swift
//  El_DUKKANA
//
//  Created by ios on 13/09/2024.
//

import Foundation

class CurrentCustomer{
    static var currentCustomer : Customer = Customer()
    static var signedUpCustomer = CustomerResult(customer: Customer(id: 0, email: "", first_name: "", last_name: "", phone: "", verified_email: true, addresses: [], password: "", password_confirmation: ""))
    
    static var CartLineItemProductId : Int = 0
    static var favLineItemProductId : Int = 0
    static var cartDraftOrderId : Int = 0
    static var favDraftOrderId : Int = 0
    static var currentCartDraftOrder : DraftOrderRequest = DraftOrderRequest(draft_order: DraftOrder(id: cartDraftOrderId, email: nil, currency: nil, created_at: nil, updated_at: nil, completed_at: nil, name: nil, status: nil, line_items: [], order_id: nil, shipping_line: nil, tags: nil, total_price: nil, customer: currentCustomer,shipping_address: nil))
    static var currentFavDraftOrder : DraftOrderRequest = DraftOrderRequest(draft_order: DraftOrder(id: favDraftOrderId, email: nil, currency: nil, created_at: nil, updated_at: nil, completed_at: nil, name: nil, status: nil, line_items: [], order_id: nil, shipping_line: nil, tags: nil, total_price: nil, customer: currentCustomer))
    static var customerAddress = AddressRequest(customer_address: CustomerAddress())
    static var customerAdresses =  AddressesResponse(addresses: [])
}
