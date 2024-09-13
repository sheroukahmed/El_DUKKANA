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
}
