//
//  SettingsVM.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import Foundation
class SettingsViewModel {
    
    let Currencies = ["EGP","USD","EUR"]
    var selectedCurrency = "EGP"
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
    
    
    func loadCurrencies() {
        network?.fetch(url: URLManager.getCurrencyURL(currentCurrency: "USD", wantedCurrency: selectedCurrency), type: Currency.self, completionHandler: { result, error in
            print(result?.rates?.EGP ?? 0)
        })
        
    }
    
    
    
    
    
    
}
