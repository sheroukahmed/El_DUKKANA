//
//  AddressDelegation.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 15/09/2024.
//

import Foundation

protocol AddressSelectionDelegate: AnyObject {
    func didSelectAddress(address: CustomerAddress)
}
