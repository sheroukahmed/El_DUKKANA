//
//  PriceRules.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import Foundation

struct DiscountCode: Codable {
    let id: Int?
    let price_rule_id: Int?
    let code: String?
    let usage_count: Int?
    let created_at: String?
    let updated_at: String?
}

struct DiscountCodeResponse: Codable {
    let discount_codes: [DiscountCode]
}

enum PriceRules :Int {
    case percent50 = 1447499530478
    case percent40 = 1447499727086
    case percent30 = 1447499694318
    case percent25 = 1447499956462
    case percent10 = 1447499792622
}


