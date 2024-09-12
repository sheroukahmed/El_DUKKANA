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
    var customerDraft: DraftOrderRequest?
    init() {
        self.network = NetworkManager()
    }
    
    func createCartDraftOrder(){
        network?.Put(url: URLManager.getUrl(for: .draftOrder), type: customerDraft, completionHandler: { result, error in
            print("\(result)")
        })
    }
    
    func getCartdraftfomApi(){
        network?.fetch(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: draftorderid)), type: DraftOrderResponse.self, completionHandler: { result, error in
            print("\(result)")
        })
    }
    
    func draftOrderCompleted(){
        network?.Put(url: URLManager.getUrl(for: .drafttorder(draftorderId:draftorderid )), type: customerDraft, completionHandler: { result, error in
            print("\(result)")
        })
        
    }
    
    
}
