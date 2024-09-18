//
//  CheckoutViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 12/09/2024.
//

import Foundation

class CheckoutViewModel {
    
    var checkoutDraft: DraftOrder?
    let network : NetworkProtocol?
    var selectedAdress : CustomerAddress?
    var bindResultToViewController: (()->()) = {}
    var bindToAddresses: (() -> Void) = {}
    var orderToPost : OrderRequest?
    
    init() {
        self.network = NetworkManager()
    }
    
    func calculatePriceWithDiscount(enteredcode :String , totalPriceString :String) -> Double {
        guard let totalPrice = Double(totalPriceString) else {
            
            return Double(totalPriceString ) ?? 0.0
        }
        
        switch enteredcode {
        case "SUMMERSALE25OFF":
            return totalPrice * (1 - (discountValue.sale25.rawValue / 100))
        case "SUMMERSALE10OFF":
            return totalPrice * (1 - (discountValue.sale10.rawValue / 100))
        case "SUMMERSALE30OFF":
            return totalPrice * (1 - (discountValue.sale30.rawValue / 100))
        case "SUMMERSALE40OFF":
            return totalPrice * (1 - (discountValue.sale40.rawValue / 100))
        case "SUMMERSALE50OFF":
            return totalPrice * (1 - (discountValue.sale50.rawValue / 100))
        default:
            
            return totalPrice
        }
    }
    
    func getAllAddresses() {
        network?.fetch(url: URLManager.getUrl(for: .customerAddresses(customerId: CurrentCustomer.currentCustomer.id ?? 0 )), type: AddressesResponse.self, completionHandler: { result, error in
            guard let result = result else{
                
                return
            }
            
            CurrentCustomer.customerAdresses.addresses = result.addresses
            
            self.bindToAddresses()
        })
        
    }
    
    
    func getDraftOrder (){
        network?.fetch(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.cartDraftOrderId)), type: DraftOrderRequest.self, completionHandler: { result, error in
            guard let result = result else { return }
            self.checkoutDraft = result.draft_order
            self.bindResultToViewController()
        })
    }
    
//    func draftOrderCompleted(){
//        var cartDraftOrderId = CurrentCustomer.currentCartDraftOrder.draft_order.id ?? 0
//        network?.Put(url: URLManager.getUrl(for: .drafttorderForOrder(draftorderId: cartDraftOrderId)), type: CurrentCustomer.currentCartDraftOrder, completionHandler: { result, error in
//            guard let result = result else{
//                print("Error in updating : \(error)")
//                return
//            }
//            print(result)
//        })
//
//    }
    
    func postNewOrder (){
        network?.Post(url: URLManager.getUrl(for: .orders), type: orderToPost , completionHandler: { result, error in
            guard let result = result else{
                print("Error in updating : \(error)")
                return
            }
            print(result)
        })
    }
    
//    func DeleteDraft(){
//        network?.Delete(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.cartDraftOrderId)))
//    }
}

enum discountValue :Double {
    case sale10 = 10.0
    case sale25 = 25.0
    case sale30 = 30.0
    case sale50 = 50.0
    case sale40 = 40.0
}

