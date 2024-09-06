//
//  HomeViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    var network: NetworkProtocol?
    var bindToHomeViewController: (() -> Void) = {}
    var brands: [SmartCollectionsItem]? {
        didSet {
            checkIfDataIsFetched()
        }
    }
    
    init() {
        network = NetworkManager()
    }
    
    func getBrands() {
        let brandURL = URLManager.getUrl(for: .brands)
        network?.fetch(url: brandURL, type: BrandsResponse.self, completionHandler: { [weak self] brand, error in
            guard let brand = brand else { return }
            self?.brands = brand.smart_collections
        })
    }
    
    private func checkIfDataIsFetched() {
        if brands != nil {
            bindToHomeViewController()
        }
    }

}
