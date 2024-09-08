//
//  Currency.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 07/09/2024.
//

import Foundation

struct Currency : Codable {
    var base :String?
    var rates : Rates?
}

struct Rates : Codable {
    var EGP : Double?
    var EUR : Double?
}
