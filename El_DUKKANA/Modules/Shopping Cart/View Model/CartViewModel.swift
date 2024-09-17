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
    var bindResultToViewController2: (() -> ()) = {}
    var productVm : ProductDetailsViewModel?
    
    var Images : [String] = []
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
    //"https://9d0444175dd62fe47c518ad17c3cd512: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@nciost3.myshopify.com./admin/api/2024-07/products.json?ids="632910392,921728736
    func getproductImage(ids:String){
        network?.fetch(url:  "https://9d0444175dd62fe47c518ad17c3cd512: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@nciost3.myshopify.com./admin/api/2024-07/products.json?ids=\(ids)", type: ProductResponse.self, completionHandler: { result, error in
            guard let result = result else{
                print("Error in fetching images : \(error)")
                return
            }
            print(result)
            for item in result.products{
                self.Images.append(item.image?.src ?? "")
            }
            self.bindResultToViewController2()
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

