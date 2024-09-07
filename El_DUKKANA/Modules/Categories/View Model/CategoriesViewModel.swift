//
//  CategoriesViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 06/09/2024.
//

import Foundation

protocol CategoriesViewModelProtocol {
    var products: [Product]? { get set }
    var bindToCategoriesViewController: (() -> Void) { get set }
    
    func getProducts()
    func checkIfDataIsFetched()
    
}

class CategoriesViewModel: CategoriesViewModelProtocol {
    
    var network: NetworkProtocol?
    var bindToCategoriesViewController: (() -> Void) = {}
    var products: [Product]? {
        didSet {
            checkIfDataIsFetched()
        }
    }
    
    init() {
        network = NetworkManager()
    }
    
    func getProducts() {
        let productURL = URLManager.getUrl(for: .products)
        print("url: \(productURL)")
        network?.fetch(url: productURL, type: ProductResponse.self, completionHandler: { [weak self] result, error in
            guard let result = result else {
                return
            }
            self?.products = result.products
        })
    }
    
    
    func checkIfDataIsFetched() {
        if products != nil {
            bindToCategoriesViewController()
        }
    }

}
