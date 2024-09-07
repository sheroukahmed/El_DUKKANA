//
//  URLManagerProtocol.swift
//  El_DUKKANA
//
//  Created by ios on 04/09/2024.
//

import Foundation

protocol URLManagerProtocol {
    static func getPath(for endpoint: EndPoint) -> String
    static func getUrl(for endpoint: EndPoint) -> String
    static func getCurrencyURL(currentCurrency: String, wantedCurrency: String)->String
}
