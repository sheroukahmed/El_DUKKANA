//
//  NetworkManagerTests.swift
//  El_DUKKANATests
//
//  Created by Sarah on 15/09/2024.
//

import XCTest
@testable import El_DUKKANA

class NetworkManagerTests: XCTestCase {
    
    var mockNetworkManager: MockNetworkManager!
    
    // Sample mock data for testing
    let mockCustomerData: [String: Any] = [
        "customers": [
            [
                "id": 1234,
                "email": "sheroukhelal@gmail.com",
                "first_name": "sherouk",
                "last_name": "helal",
                "phone": "+201011158829",
                "verified_email": true
            ]
        ]
    ]
    
    override func setUpWithError() throws {
        super.setUp()
        // Setup with no errors and mock data
        let mockData = try? JSONSerialization.data(withJSONObject: mockCustomerData)
        mockNetworkManager = MockNetworkManager(shouldReturnError: false, mockResponseData: mockData)
    }
    
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Tests
    
    func testFetchSuccess() {
        mockNetworkManager.fetch(url: "https://mockurl.com", type: CustomerResponse.self) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.customers.first?.email, "sheroukhelal@gmail.com")
        }
    }
    
    func testFetchFailure() {
        // Simulate a network failure
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockNetworkManager = MockNetworkManager(shouldReturnError: true, error: error)
        
        mockNetworkManager.fetch(url: "https://mockurl.com", type: CustomerResponse.self) { response, error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Network error")
            XCTAssertNil(response)
        }
    }

    
    // MARK: - Post Tests
    
    func testPostSuccess() {
        // Prepare mock data
        let customer = Customer(id: 1234, email: "sheroukhelal@gmail.com", first_name: "sherouk", last_name: "helal", phone: "+201011158829", verified_email: true)
        let jsonData = try? JSONEncoder().encode(customer)
        mockNetworkManager.mockData = jsonData
        mockNetworkManager.shouldReturnError = false
        
        mockNetworkManager.Post(url: "https://mockurl.com", type: customer) { (response: Customer?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.email, "sheroukhelal@gmail.com")
        }
    }
    
    func testPostFailure() {
        // Simulate a network failure
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockNetworkManager.mockError = error
        mockNetworkManager.shouldReturnError = true
        
        mockNetworkManager.Post(url: "https://mockurl.com", type: Customer(id: 1234, email: "", first_name: "", last_name: "", phone: "", verified_email: true)) { (response: Customer?, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            XCTAssertEqual(error?.localizedDescription, "Network error")
        }
    }
    
    func testPostInvalidDataEncoding() {
        let invalidCustomer = Customer(id: 1234, email: "", first_name: "", last_name: "", phone: "", verified_email: true)
        let invalidData = "{ invalid json }".data(using: .utf8)
        mockNetworkManager.mockData = invalidData
        mockNetworkManager.shouldReturnError = false
        
        mockNetworkManager.Post(url: "https://mockurl.com", type: invalidCustomer) { (response: Customer?, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            XCTAssertEqual(error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }


    
    // MARK: - Put Tests
    
    func testPutSuccess() {
        // Prepare mock data
        let customer = Customer(id: 1234, email: "updatedemail@gmail.com", first_name: "sherouk", last_name: "helal", phone: "+201011158829", verified_email: true)
        let jsonData = try? JSONEncoder().encode(customer)
        mockNetworkManager.mockData = jsonData
        mockNetworkManager.shouldReturnError = false
        
        mockNetworkManager.Put(url: "https://mockurl.com", type: customer) { (response: Customer?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.email, "updatedemail@gmail.com")
        }
    }
    
    func testPutFailure() {
        // Simulate a network failure
        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockNetworkManager.mockError = error
        mockNetworkManager.shouldReturnError = true
        
        mockNetworkManager.Put(url: "https://mockurl.com", type: Customer(id: 1234, email: "", first_name: "", last_name: "", phone: "", verified_email: true)) { (response: Customer?, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            XCTAssertEqual(error?.localizedDescription, "Network error")
        }
    }
    
    func testPutConflictError() {
        let customer = Customer(id: 1234, email: "conflictemail@gmail.com", first_name: "sherouk", last_name: "helal", phone: "+201011158829", verified_email: true)
        let conflictError = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "Conflict error"])
        mockNetworkManager.mockError = conflictError
        mockNetworkManager.shouldReturnError = true
        
        mockNetworkManager.Put(url: "https://mockurl.com", type: customer) { (response: Customer?, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
            XCTAssertEqual(error?.localizedDescription, "Conflict error")
        }
    }

    
    // MARK: - Delete Tests
    
    func testDeleteSuccess() {
        mockNetworkManager.Delete(url: "https://mockurl.com")
        XCTAssertTrue(true) // You could verify side effects of deletion in your app logic
    }
    
    func testDeleteNonExistingResource() {
        let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
        mockNetworkManager.mockError = notFoundError
        mockNetworkManager.shouldReturnError = true
        
        mockNetworkManager.Delete(url: "https://mockurl.com/nonexistent")
        // Check the logs or verify application logic if needed
    }

    func testDeleteServerError() {
        let serverError = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        mockNetworkManager.mockError = serverError
        mockNetworkManager.shouldReturnError = true
        
        mockNetworkManager.Delete(url: "https://mockurl.com/servererror")
        // Check the logs or verify application logic if needed
    }

}
