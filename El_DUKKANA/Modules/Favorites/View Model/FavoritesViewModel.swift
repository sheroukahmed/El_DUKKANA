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
    
    
    
}
