//
//  CartViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import Foundation

class CartViewModel{
    let network : NetworkProtocol?
    var draftorderid = 0
    var bindResultToViewController: (()->()) = {}
//    var cart: [LineItem]? {
//        didSet{
//            bindResultToViewController()
//           // CurrentCustomer.currentDraftOrder.draft_order.line_items = cart ?? []
//        }
//    }
    
    init() {
        self.network = NetworkManager()
    }
    /*
     getAllDrafts()
     getCartDraftFomApi()
     */
    
    
    func getAllDrafts(){
        network?.fetch(url: URLManager.getUrl(for: .draftOrder), type: DraftOrderResponse.self, completionHandler: { result, error in
            guard let result = result else{
                return
            }
            print("result of the all draft orders \(result)")
            for item in result.draft_orders {
                print("Checking Draft order email: \(item.email ?? "") against \(CurrentCustomer.currentCustomer.email ?? "")")
                if item.email ?? "".lowercased() == CurrentCustomer.currentCustomer.email{
                    CurrentCustomer.cartDraftOrderId = item.id ?? 0
                    break
                }
            }
            print("DraftOrder Id : \(CurrentCustomer.cartDraftOrderId)")
            self.getCartDraftFomApi()
        })
    }
    
    func getCartDraftFomApi(){
        network?.fetch(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.cartDraftOrderId)), type: DraftOrderRequest.self, completionHandler: { result, error in
            
            guard let result = result else{
                return
            }
            CurrentCustomer.currentCartDraftOrder.draft_order.line_items = result.draft_order.line_items
            CurrentCustomer.currentCartDraftOrder.draft_order = result.draft_order
            
        })
    }
    
    func calculateTotalPrice() -> Double {
        let cartItems = CurrentCustomer.currentCartDraftOrder.draft_order.line_items
        var totalPrice: Double = 0.0
        
        for item in cartItems {
            if let priceString = item.price, let price = Double(priceString) {
                let quantity = Double(item.quantity ?? 1)
                totalPrice += price * quantity
            }
        }
        
        return totalPrice
    }

}
