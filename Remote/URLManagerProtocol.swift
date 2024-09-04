//
//  URLManagerProtocol.swift
//  El_DUKKANA
//
//  Created by ios on 04/09/2024.
//

import Foundation

protocol URLManagerProtocol {
    func getPath(for endpoint: EndPoint) -> String
    func getUrl(for endpoint: EndPoint) -> String
    func getCurrencyURL(currentCurrency: String, wantedCurrency: String)->String
}
