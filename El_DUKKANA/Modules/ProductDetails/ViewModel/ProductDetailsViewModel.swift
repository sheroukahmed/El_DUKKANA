//
//  ProductDetailsViewModel.swift
//  El_DUKKANA
//
//  Created by ios on 06/09/2024.
//

import Foundation
import UIKit

class ProductDetailsViewModel {
    
    var product: SingleProductResponse?
    var productId = 8649736323310
    var bindResultToViewController: (() -> Void) = {}
    var network: NetworkProtocol?
    
    init() {
        self.network = NetworkManager()
    }
     
    func getData() {
        network?.fetch(url: URLManager.getUrl(for: .product(productsId: productId )), type: SingleProductResponse.self, completionHandler: {[weak self] result ,error in
            guard let self = self else {return}
            if let result = result {
                self.product = result
                print(self.product ?? "")
                self.bindResultToViewController()
                
            } else{
                print(error ?? "Unknown error occurred")
            }
            
        })
    }
    
}
