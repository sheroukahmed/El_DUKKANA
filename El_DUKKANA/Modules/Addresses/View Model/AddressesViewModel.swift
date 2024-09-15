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
//    var addresses: [CustomerAddress]? {
//        didSet {
//            bindToAddresses()
//        }
//    }
    
    init() {
        network = NetworkManager()
    }
    
    func getAllAddresses() {
        network?.fetch(url: URLManager.getUrl(for: .customerAddresses(customerId: CurrentCustomer.currentCustomer.id ?? 0 )), type: AddressesResponse.self, completionHandler: { result, error in
            guard let result = result else{
                print("Error is : \(error)")
                return
            }
            print("\n\n\n\(result.addresses.first?.id)\n\n")
            CurrentCustomer.customerAdresses.addresses = result.addresses
            print("\n\n\n\(CurrentCustomer.customerAdresses.addresses.first?.id)\n\n")
            self.bindToAddresses()
        })
        
    }
    
    func addNewAddress() {
        network?.Post(url: URLManager.getUrl(for: .customerAddresses(customerId: CurrentCustomer.currentCustomer.id ?? 0)), type: CurrentCustomer.customerAddress, completionHandler: { result, error in
            guard let result = result else{
                print("error in getting the result : \(error)")
                return
            }
            print(result)
            
            print("\n\nCustomer after posting the address : \(CurrentCustomer.currentCustomer)\n\n")
            
            
        })
        
    }
    func deleteAddresses(addressId : Int){
        network?.Delete(url: URLManager.getUrl(for: .customerAddress(customerId: CurrentCustomer.currentCustomer.id ?? 0, addressId: addressId)))

                                                }

    
}
