//
//  HomeViewModel.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import Foundation



class HomeViewModel{
    var selectedpricerule : Int = 0
    var discountCode: String = "" {
            didSet {
                discountCodeUpdated?()
            }
        }
    var discountCodeUpdated: (() -> Void)?
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
    
    func getDiscount(){
        network?.fetch(url: URLManager.getUrl(for: .discountCodes(priceruleId: selectedpricerule)), type: DiscountCodeResponse.self, completionHandler: { result, error in
            //print(result?.discount_codes.first?.code ?? "no code")
            self.discountCode = result?.discount_codes.first?.code ?? "no code"
        })
        
    }
    

    func checkIfDataIsFetched() {
        
        if brands != nil {
            bindToHomeViewController()
            
        }
    }


}

