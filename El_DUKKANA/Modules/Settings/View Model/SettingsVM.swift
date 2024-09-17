//
//  SettingsVM.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import Foundation
class SettingsViewModel {
    
    let Currencies = ["EGP","USD","EUR"]
    var selectedCurrency: String {
        get {
            return UserDefaults.standard.string(forKey: "SelectedCurrency") ?? "EGP"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SelectedCurrency")
            loadCurrencies()
        }
    }
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
            if let result = result, let rates = result.rates {
                var selectedRate: Double?
                
                switch self.selectedCurrency {
                case "EGP":
                    selectedRate = rates.EGP
                case "USD":
                    selectedRate = rates.USD
                case "EUR":
                    selectedRate = rates.EUR
                default:
                    selectedRate = nil
                }
                
                if let selectedRate = selectedRate {
                    self.currencyRate = [self.selectedCurrency: selectedRate]
                    UserDefaults.standard.set(selectedRate, forKey: "CurrencyRate")
                    print("Updated rates for \(self.selectedCurrency): \(rates)")
                } else {
                    print("Failed to load currency rates")
                }
            }
        })
    }
    
}

extension NSNotification.Name {
    static let currencyDidChange = NSNotification.Name("currencyDidChange")
}
                       
            
            
                    
