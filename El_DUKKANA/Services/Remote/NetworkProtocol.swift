//
//  NetworkProtocol.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 05/09/2024.
//

import Foundation

protocol NetworkProtocol {
    
    func fetch<T: Codable>(url: String, type: T.Type, completionHandler: @escaping (T?, Error?) -> Void)
    func Post<T: Codable>(url: String, type: T, completionHandler: @escaping (T?, Error?) -> Void)
    func Put<T: Codable>(url: String, type: T, completionHandler: @escaping (T?, Error?) -> Void)
    func Delete(url:String)
    
}
