//
//  Customer.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 05/09/2024.
//

import Foundation

struct CustomerResponse: Codable {
    let customers: [Customer]
}
struct CustomerResult: Codable {
    var cust :Customer
}

struct Customer: Codable {
    let id: Int?
    let email: String?
    let first_name: String?
    let last_name: String?
    let phone: String?
    let verified_email: Bool?
    let addresses: [CustomerAddress]?
    let password: String?
    let password_confirmation: String?
    
}
 
struct CustomerAddress: Codable {
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
}
