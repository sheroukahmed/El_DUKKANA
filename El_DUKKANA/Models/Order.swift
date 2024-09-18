//
//  Order.swift
//  El_DUKKANA
//
//  Created by Sarah on 12/09/2024.
//

import Foundation

struct OrderResponse: Codable {
    let orders: [Order]
}

struct OrderRequest: Codable {
    let order: Order
}

struct Order: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let currency: String?
    let name: String?
    //let tags: String?
    var processed_at: String?
    let line_items: [LineItem]?
    //let subtotal_price: String?
   // let total_discounts: String?
    let total_price: String?
    let customer: Customer?
    let shipping_address: CustomerAddress?
    
}
