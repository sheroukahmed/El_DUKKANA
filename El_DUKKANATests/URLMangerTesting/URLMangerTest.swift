//
//  URLMangerTest.swift
//  El_DUKKANATests
//
//  Created by  sherouk ahmed  on 07/09/2024.
//

import XCTest
@testable import El_DUKKANA

final class URLMangerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPath() {
       
        XCTAssertEqual(URLManager.getPath(for: .customers), "/customers")
        
     
        XCTAssertEqual(URLManager.getPath(for: .customer(customerId: 123)), "/customers/123")
        
       
        XCTAssertEqual(URLManager.getPath(for: .customerOrders(customerId: 123)), "/customers/123/orders")
        
      
        XCTAssertEqual(URLManager.getPath(for: .customerAddresses(customerId: 123)), "/customers/123/addresses")
        
        
        XCTAssertEqual(URLManager.getPath(for: .customerAddress(customerId: 123, addressId: 456)), "/customers/123/addresses/456")
        
        
        XCTAssertEqual(URLManager.getPath(for: .order(orderId: 456)), "/orders/456")
        
        
        XCTAssertEqual(URLManager.getPath(for: .orders), "/orders")
        
    
        XCTAssertEqual(URLManager.getPath(for: .products), "/products")
        
        
        XCTAssertEqual(URLManager.getPath(for: .product(productsId: 789)), "/products/789")
        
        
        XCTAssertEqual(URLManager.getPath(for: .brands), "/smart_collections")
        
        
   //     XCTAssertEqual(URLManager.getPath(for: .discountCodes), "/price_rules")
    }

       
       func testGetUrl() {
           let expectedUrl = "https://9d0444175dd62fe47c518ad17c3cd512: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@nciost3.myshopify.com./admin/api/2024-07/customers.json"
           XCTAssertEqual(URLManager.getUrl(for: .customers), expectedUrl)
       }
       
       func testGetCurrencyURL() {
           let expectedCurrencyUrl = "https://openexchangerates.org/api/latest.json?app_id=db875dafb94e48bc82fd4dd574f85d33&base=USD&symbols=EUR"
           XCTAssertEqual(URLManager.getCurrencyURL(currentCurrency: "USD", wantedCurrency: "EUR"), expectedCurrencyUrl)
       }
}
