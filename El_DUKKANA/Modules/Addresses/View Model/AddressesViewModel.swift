//
//  AddressesViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 13/09/2024.
//

import Foundation

class AddressesViewModel {
    
    var network: NetworkProtocol?
    var bindToAddresses: (() -> Void) = {}
    var addresses: [CustomerAddress]? {
        didSet {
            bindToAddresses()
        }
    }
    
    init() {
        network = NetworkManager()
    }
    
    func getAllAddresses() {
        
        
    }
    
    func addNewAddress() {
        
        
    }
    
}
