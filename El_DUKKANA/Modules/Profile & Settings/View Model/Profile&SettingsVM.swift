//
//  Profile&SettingsVM.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 07/09/2024.
//

import Foundation

class ProfileAndSettingsViewModel {
    
    var network: NetworkProtocol?
    var bindResultToViewController: (() -> Void) = {}
    var currencyRate: [String: Double]? {
        didSet{
            bindResultToViewController()
        }
    }
    
    init() {
        network = NetworkManager()
    }
    
    
    func loadCurrencies() {}
    
    
    
    
    
    
}
