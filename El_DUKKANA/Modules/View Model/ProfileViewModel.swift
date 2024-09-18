//
//  ProfileViewModel.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 11/09/2024.
//

import Foundation
class ProfileViewModel{
    
    var Images : [String] = []
    var bindResultToViewController2: (() -> ()) = {}
    let network = NetworkManager()
    func getproductImage(ids:String){
        network.fetch(url:  "https://9d0444175dd62fe47c518ad17c3cd512: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@nciost3.myshopify.com./admin/api/2024-07/products.json?ids=\(ids)", type: ProductResponse.self, completionHandler: { result, error in
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
}
