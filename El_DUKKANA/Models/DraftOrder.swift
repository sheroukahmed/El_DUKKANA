//
//  DraftOrder.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import Foundation

struct DraftOrderResponse: Codable {
    let draft_orders: [DraftOrder]
    
}

struct DraftOrderRequest: Codable {
    var draft_order: DraftOrder
}

struct DraftOrder: Codable {
    var id: Int?
    let email: String?
    let currency: String?
    let created_at: String?
    let updated_at: String?
    let completed_at: String?
    let name: String?
    let status: String?
    var line_items: [LineItem]
    let order_id: String?
    let shipping_line: String?
    let tags: String?
    let total_price: String?
    let customer: Customer?
    
}

struct LineItem: Codable  {
    var id: Int?
    let variant_id: Int?
    let product_id: Int?
    let title: String?
    let variant_title: String?
    let vendor: String?
    var quantity: Int?
    let name: String?
    let custom: Bool?
    let price: String?
    let properties : [ProductProperties]?
}

struct ProductProperties: Codable {
    let image : String
    
}
