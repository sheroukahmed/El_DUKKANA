//
//  CheckoutViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 12/09/2024.
//

import Foundation

class CheckoutViewModel {
    var draftorderid = 0
    var customerDraft: DraftOrderRequest?
    let network : NetworkProtocol?
    var bindResultToViewController: (()->()) = {}
    
    
    init() {
        self.network = NetworkManager()
    }
    
    func draftOrderCompleted(){
        var cartDraftOrderId = CurrentCustomer.currentCartDraftOrder.draft_order.id
        network?.Put(url: URLManager.getUrl(for: .drafttorderForOrder(draftorderId: draftorderid)), type: CurrentCustomer.currentCartDraftOrder, completionHandler: { result, error in
            print(result)
        })
        
    }
}
