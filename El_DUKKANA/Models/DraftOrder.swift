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
    var note: String?
    let email: String?
    let currency: String?
    let created_at: String?
    let updated_at: String?
    let completed_at: String?
    let name: String?
    let status: String?
    var line_items: [LineItem]
    let order_id: Int?
    let shipping_line: String?
    let tags: String?
    var total_price: String?
    let customer: Customer?
    var shipping_address: CustomerAddress?
    
    
}
/*
 shipping_address": {
       "first_name": "Bob",
       "address1": "Chestnut Street 92",
       "phone": "+1(502)-459-2181",
       "city": "Louisville",
       "zip": "40202",
       "province": "Kentucky",
       "country": "United States",
       "last_name": "Norman",
       "address2": "",
       "company": null,
       "latitude": 45.41634,
       "longitude": -75.6868,
       "name": "Bob Norman",
       "country_code": "US",
       "province_code": "KY"
     },
 has context menu
 */
struct ShippingAddress: Codable  {
    
    var address1: String?
    var address2: String?
    var city: String?
    var province: String?
    var country: String?
    var zip: String?
    
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
