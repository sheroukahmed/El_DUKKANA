//
//  CategoriesViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 06/09/2024.
//

import Foundation

protocol CategoriesViewModelProtocol {
    var products: [Product]? { get set }
    var isLoading: Bool { get set }
    var bindToCategoriesViewController: (() -> Void) { get set }
    
    func getAllProducts()
    func getProducts(collectionId: CollectionID, productType: ProductType)
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
   
    
    var isLoading: Bool = false {
           didSet {
               bindToCategoriesViewController()
           }
       }
    
    init() {
        network = NetworkManager()
    }

    
    func getAllProducts() {
        self.isLoading = true
        let url = URLManager.getUrl(for: .products)
        print("url: \(url)")
        network?.fetch(url: url, type: ProductResponse.self, completionHandler: { [weak self] result, error in
            self?.isLoading = false
            guard let result = result else {
                return
            }
            self?.products = result.products
        })
    }
    
    func getProducts(collectionId: CollectionID, productType: ProductType) {
        self.isLoading = true
        let url = URLManager.getUrl(for: .products)
        let additionalParameters = "?collection_id=\(getCollectionID(for: collectionId) ?? 0)&product_type=\(getProductType(for: productType))"
        let fullURL = url+additionalParameters
        print("url: \(fullURL)")
        network?.fetch(url: fullURL, type: ProductResponse.self, completionHandler: { [weak self] result, error in
            self?.isLoading = false
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
    
    private func getCollectionID(for collectionId: CollectionID) -> Int? {
        switch collectionId {
        case .all:
            return nil
        case .men:
            return 438260170990
        case .women:
            return 438260203758
        case .kids:
            return 438260236526
        case .sale:
            return 438260269294
        }
    }
    
    private func getProductType(for productType: ProductType) -> String {
        switch productType {
        case .shoes:
            return "SHOES"
        case .t_shirt:
            return "T-SHIRT"
        case .accessories:
            return "ACCESSORIES"
        }
    }
}

enum CollectionID: Any {
    case all
    case men
    case women
    case kids
    case sale
}

enum ProductType: Any {
    case shoes
    case t_shirt
    case accessories
}
