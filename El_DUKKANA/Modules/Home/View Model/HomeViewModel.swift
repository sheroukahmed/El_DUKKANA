//
//  HomeViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var brands: [SmartCollectionsItem]? { get set }
    var bindToHomeViewController: (() -> Void) { get set }
    
    func getBrands()
    func checkIfDataIsFetched()
    
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
        print("url: \(brandURL)")
        network?.fetch(url: brandURL, type: BrandsResponse.self, completionHandler: { [weak self] result, error in
            guard let result = result else {
                return
            }
            self?.brands = result.smart_collections
        })
    }
    
    
    func checkIfDataIsFetched() {
        
        var network: NetworkProtocol?
        var bindToHomeViewController: (() -> Void) = {}
        var brands: [SmartCollectionsItem]? {
            didSet {
                checkIfDataIsFetched()
            }
        }
        
       
        
        func getBrands() {
            let brandURL = URLManager.getUrl(for: .brands)
            network?.fetch(url: brandURL, type: BrandsResponse.self, completionHandler: { [weak self] brand, error in
                guard let brand = brand else { return }
                self?.brands = brand.smart_collections
            })
        }
        
         func checkIfDataIsFetched() {
            
            if brands != nil {
                bindToHomeViewController()
            }
        }
        
    }
}
