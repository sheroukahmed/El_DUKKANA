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
    var favViewModel = FavoritesViewModel()
//    var cart: [LineItem]? {
//        didSet{
//            bindResultToViewController()
//           // CurrentCustomer.currentDraftOrder.draft_order.line_items = cart ?? []
//        }
//    }
    
    init() {
        self.network = NetworkManager()
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
