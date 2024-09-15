//
//  CartViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//


import Foundation
import RxSwift
import RxCocoa

class CartViewModel {
    let network: NetworkProtocol?
    var bindResultToViewController: (() -> ()) = {}
    var productVm : ProductDetailsViewModel?
    
    
    var disposeBag = DisposeBag()
    var quantityUpdateSubject = PublishSubject<Void>()

    
    init() {
        self.network = NetworkManager()
        self.productVm = ProductDetailsViewModel()
        quantityUpdateSubject
           .debounce(.seconds(2), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self] in
               self?.productVm?.updateCartDraftOrder()
               
           DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
               self?.getCartDraftFromApi()
                               }
               
           })
           .disposed(by: disposeBag)
        
    }
    
    func getCartDraftFromApi() {
        network?.fetch(url: URLManager.getUrl(for: .specifcDraftorder(specificDraftOrder: CurrentCustomer.cartDraftOrderId)), type: DraftOrderRequest.self, completionHandler: { result, error in
            guard let result = result else { return }
            CurrentCustomer.currentCartDraftOrder.draft_order.line_items = result.draft_order.line_items
            CurrentCustomer.currentCartDraftOrder.draft_order = result.draft_order
            self.bindResultToViewController()
        })
    }
    
   
//    func calculateTotalPrice() -> Double {
//        let cartItems = CurrentCustomer.currentCartDraftOrder.draft_order.line_items
//        var totalPrice = 0.0
//        
//        for item in cartItems {
//            if let priceString = item.price, let price = Double(priceString) {
//                let quantity = Double(item.quantity ?? 1)
//                totalPrice += price * quantity
//            }
//        }
//        
//        return totalPrice
//    }
}

