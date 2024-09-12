//
//  CustomerViewModel.swift
//  El_DUKKANA
//
//  Created by ios on 11/09/2024.
//

import Foundation

class CustomerViewModel{
    var network : NetworkProtocol?
    var customer = Customer(id: 7828790968558, email: "samir7.sherouk@gmail.com", first_name: "sara", last_name: "And sherouk", phone: "+201165015450", verified_email: true, addresses: [CustomerAddress(address1: "sherouk", address2: "Lastnameson", city: "Ottawa", province: "Ontario", country: "Canada", zip: "123 ABC")], password: "123abc", password_confirmation: "123abc")

    var customerDraftFav: DraftOrderRequest?
    var customerDraftCart: DraftOrderRequest?
    init() {
        self.network = NetworkManager()
    }
    
    func addCustomer(){
        network?.Post(url: URLManager.getUrl(for: .customers), type: customer, completionHandler: { result, error in
            self.network?.Post(url: URLManager.getUrl(for: .draftOrder), type: self.customerDraftFav, completionHandler: { res, error in
            })
            self.network?.Post(url: URLManager.getUrl(for: .draftOrder), type: self.customerDraftCart, completionHandler: { res, error in
            })
        })
    }
}
