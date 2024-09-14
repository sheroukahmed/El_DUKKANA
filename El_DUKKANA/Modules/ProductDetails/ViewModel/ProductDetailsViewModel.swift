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
    func updateCartDraftOrder(){
        network?.Put(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.currentCartDraftOrder.draft_order.id ?? 0)), type: CurrentCustomer.currentCartDraftOrder, completionHandler: { result, error in
            guard error == nil else {
                print("Error editing draft order: \(String(describing: error))")
                return
            }
            guard let result = result else {
                print("No result returned when Editing draft order")
                return
            }
            print("\n\n CurrentCustomer.currentDraftOrder for puting : \(CurrentCustomer.currentCartDraftOrder)")
            
            print("\n\n the id : \(CurrentCustomer.currentCartDraftOrder.draft_order.id ?? 0)")
            
            CurrentCustomer.currentCartDraftOrder.draft_order = result.draft_order
            print("line items after put 1: \(result.draft_order.line_items)")
            print("line items after put 2: \(CurrentCustomer.currentCartDraftOrder.draft_order)")
            
        })
    }
    func updateFavDraftOrder(){
        network?.Put(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.currentFavDraftOrder.draft_order.id ?? 0)), type: CurrentCustomer.currentFavDraftOrder, completionHandler: { result, error in
            guard error == nil else {
                print("Error editing draft order: \(String(describing: error))")
                return
            }
            guard let result = result else {
                print("No result returned when Editing draft order")
                return
            }
            print("\n\n CurrentCustomer.currentDraftOrder for puting : \(CurrentCustomer.currentFavDraftOrder)")
            
            print("\n\n the id : \(CurrentCustomer.currentFavDraftOrder.draft_order.id ?? 0)")
            
            CurrentCustomer.currentFavDraftOrder.draft_order = result.draft_order
            print("line items after put 1: \(result.draft_order.line_items)")
            print("line items after put 2: \(CurrentCustomer.currentFavDraftOrder.draft_order)")
            
        })
    }
    
}
