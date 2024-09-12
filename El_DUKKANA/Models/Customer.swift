//
//  Customer.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 05/09/2024.
//

import Foundation

struct CustomerResponse: Codable {
    var customers: [Customer]
}
struct CustomerResult: Codable {

    var customer :Customer

}

struct Customer: Codable {
    var id: Int?
    var email: String?
    var first_name: String?
    var last_name: String?
    var phone: String?
    var verified_email: Bool?
    var addresses: [CustomerAddress]?
    var password: String?
    var password_confirmation: String?
    
}
 
struct CustomerAddress: Codable {
    var address1: String?
    var address2: String?
    var city: String?
    var province: String?
    var country: String?
    var zip: String?
}
