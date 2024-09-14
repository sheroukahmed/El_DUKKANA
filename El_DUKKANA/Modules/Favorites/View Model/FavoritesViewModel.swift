//
//  FavoritesViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import Foundation

class FavoritesViewModel {
    
    var network: NetworkProtocol?
    var bindToFavorites: (() -> Void) = {}
    var favorites: [Product]? {
        didSet {
            bindToFavorites()
        }
    }
    
    init() {
        network = NetworkManager()
    }
    
    
    func getFavorites() {
        
        
    }

    func getFavDraftFomApi(){
        network?.fetch(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.favDraftOrderId)), type: DraftOrderRequest.self, completionHandler: { result, error in
            
            guard let result = result else{
                return
            }
            CurrentCustomer.currentFavDraftOrder.draft_order.line_items = result.draft_order.line_items
            CurrentCustomer.currentFavDraftOrder.draft_order = result.draft_order
            
        })
    }
    
    
    
    
}
