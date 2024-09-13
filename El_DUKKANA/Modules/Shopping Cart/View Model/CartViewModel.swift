//
//  CartViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import Foundation

class CartViewModel{
    let network : NetworkProtocol?
    var draftorderid = 1220224712942
    var customerDraft: DraftOrderRequest?
    var bindResultToViewController: (()->()) = {}
    var cart: [LineItem]? {
        didSet{
            bindResultToViewController()
        }
    }
    init() {
        self.network = NetworkManager()
    }
    
    func updateCartDraftOrder(cartItems: [LineItem]?){
        network?.Put(url: URLManager.getUrl(for: .draftOrder), type: customerDraft, completionHandler: { result, error in
            print("\(result)")
        })
    }
    
    func getCartdraftfomApi(){
        network?.fetch(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: draftorderid)), type: DraftOrderRequest.self, completionHandler: { result, error in
            self.cart = result?.draft_order.line_items
        })
    }
    
    func calculateTotalPrice() -> Double {
        guard let cartItems = cart else { return 0.0 }
        
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
