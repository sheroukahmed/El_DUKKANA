//
//  CurrencyManager.swift
//  El_DUKKANA
//
//  Created by Sarah on 16/09/2024.
//

import Foundation

class CurrencyManager {
    
    static let shared = CurrencyManager()
    
    private init() {}
    
    var selectedCurrency: String {
        return UserDefaults.standard.string(forKey: "SelectedCurrency") ?? "EGP"
    }
    
    var currencyRate: Double {
        return UserDefaults.standard.double(forKey: "CurrencyRate")
    }
}
