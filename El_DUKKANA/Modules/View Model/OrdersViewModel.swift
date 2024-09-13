//
//  OrdersViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 12/09/2024.
//

import Foundation

class OrdersViewModel {
    
    var network: NetworkProtocol?
    var bindToOrders: (() -> Void) = {}
    var orders: [Order]? {
        didSet {
            bindToOrders()
        }
    }
    
    init() {
        network = NetworkManager()
    }
    
    func getAllOrders() {
        let url = URLManager.getUrl(for: .orders)
        print("URL: \(url)")
        network?.fetch(url: url, type: OrderResponse.self, completionHandler: { [weak self] result,error in
            guard let result = result else {
                return
            }
            self?.orders = result.orders
        })
    }
    
}
