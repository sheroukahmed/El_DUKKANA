//
//  BrandViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 07/09/2024.
//

import Foundation

protocol BrandViewModelProtocol {
    var products: [Product]? { get set }
    var filteredProducts: [Product]? { get set }
    var bindToBrandViewController: (() -> Void) { get set }
    
    func getProducts()
    func checkIfDataIsFetched()
    func filterProducts()
    
}


class BrandViewModel {
    
    var network: NetworkProtocol?
    var bindToBrandViewController: (() -> Void) = {}
    var brand: String?
    var products: [Product]? = [] {
        didSet {
            checkIfDataIsFetched()
        }
    }
    var filteredProducts: [Product]? = [] {
        didSet {
            checkIfDataIsFetched()
        }
    }
    
    init(brand: String) {
        network = NetworkManager()
        self.brand = brand
    }
    
    func getProducts() {
        let productURL = URLManager.getUrl(for: .products)
        print("url: \(productURL)")
        network?.fetch(url: productURL, type: ProductResponse.self, completionHandler: { [weak self] result, error in
            guard let result = result else {
                return
            }
            for item in result.products {
                if item.vendor == self?.brand?.uppercased() {
                    self?.products?.append(item)
                }
            }
            self?.bindToBrandViewController()
        })
    }
    
    
    func checkIfDataIsFetched() {
        if products != nil {
            bindToBrandViewController()
        }
    }
    
    func filterProducts() {
        filteredProducts = products?.sorted{Double( $0.variants?.first?.price ?? "0.0") ?? 0.0 < Double( $1.variants?.first?.price ?? "0.0") ?? 0.0
        }
    }
    
}
