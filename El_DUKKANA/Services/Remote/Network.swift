//
//  Network.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 05/09/2024.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func fetch<T: Codable>(url: String, type: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
       
        guard let newURL = URL(string: url) else {
            completionHandler(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        print("Fetching data from URL: \(newURL)")
        
        AF.request(newURL).response { response in
            guard let data = response.data else {
                completionHandler(nil, response.error)
                return
            }
            
            print("fetching in background")
            print(data)
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                print(data)
                completionHandler(result, nil)
            } catch let error {
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        }
    }
    
    
    func Post(url: String, type: Customer, completionHandler: @escaping (Customer?, Error?) -> Void) {
       
        guard let newURL = URL(string: url) else {
            completionHandler(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        print("posting data to URL: \(newURL)")
        
        
        guard let customerData = try? JSONEncoder().encode(type),
              let customerDictionary = try? JSONSerialization.jsonObject(with: customerData, options: []) as? [String: Any] else {
            completionHandler(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode customer data"]))
            return
        }
        print("Customer Dictionary: \(customerDictionary)")


        //var Headers : HTTPHeaders = ["Content-Type" : "application/json"]
        AF.request(newURL, method: .post , parameters: customerDictionary , encoding :JSONEncoding.default , headers:[.contentType(
            "application/json"
            ), .accept(
            "application/json"
            )]).response { response in
            switch response.result{
            case .success :
                if let data = response.data {
                    do{
                        let result = try JSONSerialization.jsonObject(with: data )
                        print(result)
                        let decodedCustomer = try JSONDecoder().decode(Customer.self, from: data)
                        completionHandler(decodedCustomer, nil)
                    }catch let error{
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            
            }
            
            print("fetching in background")
        
        }
    }
    
    
    
}

