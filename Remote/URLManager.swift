//
//  URLManager.swift
//  El_DUKKANA
//
//  Created by ios on 04/09/2024.
//


import Foundation
 
class URLManager : URLManagerProtocol{
    enum URLComponents : String{
        case apiKey = "9d0444175dd62fe47c518ad17c3cd512"
        case accessToken = "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"
        case shopifyStore = "@nciost3.myshopify.com."
    }
    
    
    class func getPath(for endpoint: EndPoint) -> String {
        switch endpoint {
        case .customers:
            return "/customers"
        case .customer(let customerId):
            return "/customers/\(customerId)"
        case .customerOrders(let customerId):
            return "/customers/\(customerId)/orders"
        case .customerAddresses(let customerId):
            return "/customers/\(customerId)/addresses"
        case .customerAddress(let customerId, let addressId):
            return "/customers/\(customerId)/addresses/\(addressId)"
        case .order(let orderId):
            return "/orders/\(orderId)"
        case .orders:
            return "/orders"
        case .products:
            return "/products"
        case .product(let productId):
            return "/products/\(productId)"
        case .brands:
            return "/smart_collections"
        case .discountCodes(let priceruleId):
            return "/price_rules/\(priceruleId)/discount_codes"
        case .collection(let collectionId):
            return "/collections/\(collectionId)/products"

            
            
        }
    }
        
    //shopify Api
    
        
       class func getUrl(for endpoint: EndPoint) -> String{
            
            let path =  getPath(for: endpoint)
            let baseUrl = "https://\(URLComponents.apiKey.rawValue):\(URLComponents.accessToken.rawValue)\(URLComponents.shopifyStore.rawValue)/admin/api/2024-07"
            
            return "\(baseUrl)\(path).json"
        }
    
 
    
 
 
    // Currency Api
    class func getCurrencyURL(currentCurrency: String, wantedCurrency: String)->String{
        let appId = "db875dafb94e48bc82fd4dd574f85d33"
        let baseUrl = "https://openexchangerates.org/api/latest.json?app_id=\(appId)&base="
        return "\(baseUrl)\(currentCurrency)&symbols=\(wantedCurrency)"
    }
}
 
 
enum EndPoint: Any {
    case customers
    case customer(customerId: Int)
    case customerOrders(customerId: Int)
    case customerAddresses(customerId: Int)
    case customerAddress(customerId: Int,addressId: Int)
    case order(orderId: Int)
    case orders
    case products
    case product(productsId: Int)
    case brands

    case discountCodes(priceruleId :Int)

    case discountCodes
    case collection(collectionId: Int)

    
    
}
