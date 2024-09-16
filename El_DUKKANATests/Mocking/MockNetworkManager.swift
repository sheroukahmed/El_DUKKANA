//
//  MockNetworkManager.swift
//  El_DUKKANATests
//
//  Created by Sarah on 15/09/2024.
//

import XCTest
@testable import El_DUKKANA

class MockNetworkManager: NetworkProtocol {

    var mockData: Data?
    var mockError: Error?
    var shouldReturnError: Bool = false
    
    init(shouldReturnError: Bool, mockResponseData: Data? = nil, error: Error? = nil) {
           self.shouldReturnError = shouldReturnError
           self.mockData = mockResponseData
           self.mockError = error
       }

    func fetch<T: Codable>(url: String, type: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        if shouldReturnError {
            completionHandler(nil, mockError)
        } else if let data = mockData {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }

    func Post<T: Codable>(url: String, type: T, completionHandler: @escaping (T?, Error?) -> Void) {
        if shouldReturnError {
            completionHandler(nil, mockError)
        } else if let data = mockData {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }

    func Put<T: Codable>(url: String, type: T, completionHandler: @escaping (T?, Error?) -> Void) {
        if shouldReturnError {
            completionHandler(nil, mockError)
        } else if let data = mockData {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }

    func Delete(url: String) {
        if shouldReturnError {
            print("Delete failed with error: \(mockError?.localizedDescription ?? "Unknown error")")
        } else {
            print("Delete successful for URL: \(url)")
        }
    }
}
