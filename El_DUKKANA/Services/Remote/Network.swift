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

