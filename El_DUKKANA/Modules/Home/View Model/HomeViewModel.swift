//
//  HomeViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import Foundation
/*
protocol HomeViewModelProtocol: Any {
    func getBrands()
    func checkIfDataIsFetched()
    
}
*/
class HomeViewModel {
    
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
                print("Failed to fetch")
                return
            }
            self?.brands = result.smart_collections
            print("Fetched")
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
