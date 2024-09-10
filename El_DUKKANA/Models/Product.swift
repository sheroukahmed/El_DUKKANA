//
//  Product.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}
struct SingleProductResponse: Codable {
    var product : Product
}

struct Product: Codable {
    let id: Int?
    let title: String?
    let body_html: String?
    let vendor: String?
    let product_type: String?
    let tags: String?
    let variants: [Variant]?
    let options: [Option]?// here
    let images: [ProductImage]?
    let image: ProductImage?
    
}

struct Variant: Codable {
    let id: Int?
    let product_id: Int?
    let title: String?
    let price: String?
    //presentment_prices: [PresentmentPrices]
    let option1: String?
    let option2: String?
    let option3: String?
    let inventory_item_id: Int?
    let inventory_quantity: Int?
    let old_inventory_quantity: Int?
    
}
/*
 struct PresentmentPrices {
    let : []
 */

struct Option: Codable {
    let id: Int?
    let product_id : Int?
    let name: String?
    let position: Int?
    let values: [String]?
    
}

struct ProductImage: Codable {
    let id: Int?
    let position: Int?
    let src: String?
    
}
