//
//  CartViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import Foundation

class CartViewModel{
    let network : NetworkProtocol?
    var customerDraft: DraftOrderRequest?
    init() {
        self.network = NetworkManager()
    }
    
    func createCartDraftOrder(){
        network?.Post(url: URLManager.getUrl(for: .draftOrder), type: customerDraft, completionHandler: { result, error in
            print("\(result)")
        })
    }
}
