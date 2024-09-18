//
//  MockNetwork.swift
//  El_DUKKANATests
//
//  Created by Sarah on 15/09/2024.
//

import XCTest
@testable import El_DUKKANA

class MockNetwork {
    
    var shouldReturnError: Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    let fakeJSON: [String: Any] = [
        "customers": [
            [
                "id": 1234,
                "email": "sheroukhelal@gmail.com",
                "first_name": "sherouk",
                "last_name": "helal",
                "phone": "+201011158829",
                "verified_email": true
            ],
            [
                "id": 1122,
                "email": "saraelnaggar@gmail.com",
                "first_name": "sarah",
                "last_name": "elnaggar",
                "phone": "+201099693982",
                "verified_email": true
            ]
        ]
    ]
}

extension MockNetwork {
    func fetch(completionHandler: @escaping (CustomerResponse?, Error?) -> Void) {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeJSON)
            let result = try JSONDecoder().decode(CustomerResponse.self, from: data)
            
            enum ResponseError: Error {
                case responseError
            }
            
            if shouldReturnError {
                // Return error
                completionHandler(nil, ResponseError.responseError)
            } else {
                // Return mock data
                completionHandler(result, nil)
            }
        } catch let error {
            print("Decoding error: \(error.localizedDescription)")
            completionHandler(nil, error)
        }
    }
}
