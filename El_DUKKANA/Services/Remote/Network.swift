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
    

    

    func Post<T: Codable>(url: String, type: T, completionHandler: @escaping (T?, Error?) -> Void) {
        
        do {
            guard let newURL = URL(string: url) else {
                completionHandler(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }
            print("Posting data to URL: \(newURL)")
            
            // Encode CustomerResponse to JSON data
            let inputData = try JSONEncoder().encode(type)
            
            print("Customer Data: \(String(data: inputData, encoding: .utf8) ?? "Encoding error")")
            let inputDataInDictionary = try JSONSerialization.jsonObject(with: inputData, options: []) as? [String: Any]
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": "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",
                "Content-Type": "application/json"
            ]
            
            // Alamofire POST request with JSON data
            AF.request(newURL, method: .post, parameters: inputDataInDictionary, encoding: JSONEncoding.default,headers: headers ).validate(statusCode: 200..<299)
                .responseJSON{ response in
                    switch response.result {
                    case .success(let result):
                        print("Success: \(result)")
                    case .failure(let error):
                        print("Request failed: \(error.localizedDescription)")
                        if let data = response.data {
                            let responseString = String(data: data, encoding: .utf8)
                            print("Response Data: \(responseString ?? "No data")")
                        }
                    }
                }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    
    
    

    func deleteFromApi(url:String){
        
        guard let newURL = URL(string: url) else {
            return
        }
        print("deleting data to URL: \(newURL)")
        
        AF.request(newURL, method: .delete,headers:[.contentType(
            "application/json"
            ), .accept(
            "application/json"
            )] )
            .response { response in
                if let error = response.error {
                    print("Error deleting item: \(error)")
                } else {
                    if let data = response.data {
                        print("Success: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    print("Item deleted successfully")
                }
            }
    }

}

