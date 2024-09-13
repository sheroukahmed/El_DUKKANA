


class CustomerViewModel {
    var network: NetworkProtocol?
    var customer : CustomerResult = CustomerResult(customer: Customer(id: 7828790964558, email: "", first_name: "", last_name: "", phone: "", verified_email: true, addresses: [], password: "", password_confirmation: ""))
    var customeremail = ""
    var customerID = 0
    var customerDraftFav: DraftOrderRequest?
    var customerDraftCart: DraftOrderRequest?
    
    init() {
        self.network = NetworkManager()
    }
    
    func getAllCustomer() {
        network?.fetch(url: URLManager.getUrl(for: .customers), type: CustomerResponse.self, completionHandler: { result, error in
            guard let result = result else {
                print("No customers returned from the API")
                return
            }
            
            for item in result.customers {
                print("Checking customer email: \(item.email) against \(self.customeremail)")
                if item.email?.lowercased() == self.customeremail.lowercased() {
                    self.customerID = item.id ?? 0
                    print("Customer found with ID: \(self.customerID)")
                    break
                }
            }
            
            if self.customerID == 0 {
                print("No customer found with the email: \(self.customeremail)")
            } else {
                // Now fetch the customer with the valid customer ID
                self.getAcustomer(customerId: self.customerID)
            }
        })
    }
    
    func addCustomer() {
        network?.Post(url: URLManager.getUrl(for: .customers), type: CurrentCustomer.signedUpCustomer, completionHandler: { result, error in
            
            guard error == nil else {
                print("Error adding customer: \(String(describing: error))")
                return
            }
            print("samir")
            guard let result = result else {
                print("No result returned when adding customer")
                return
            }
            print(result)

            // Customer added successfully, update CurrentCustomer with the result
            CurrentCustomer.signedUpCustomer = result
            print("Signed Up Customer : \(CurrentCustomer.signedUpCustomer)")
            // Ensure customer ID is valid before proceeding
            guard let customerID = result.customer.id, customerID != 0 else {
                print("Error: Customer ID is invalid.")
                return
            }

            self.prepareDraftOrders()
            self.addDraftOrders()
            
        })
    }

    func getAcustomer(customerId : Int){
        guard customerId != 0 else {
            print("Invalid customer ID: \(customerId)")
            return
        }
        
        network?.fetch(url: URLManager.getUrl(for: .customer(customerId: customerId)), type: CustomerResult.self, completionHandler: { result, error in
            if let error = error {
                print("Error fetching customer: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No result returned from the API")
                return
            }
            
            // Update current customer with the fetched data
            CurrentCustomer.currentCustomer = result.customer
            print("Current Customer: \(CurrentCustomer.currentCustomer)")
        })
    }
    
    func prepareDraftOrders() {
        // Setup draft orders for the customer
        
        customerDraftFav = DraftOrderRequest(draft_order: DraftOrder(id: 342523442, email: CurrentCustomer.signedUpCustomer.customer.email, currency: "USD", created_at: "2024-9-4", updated_at: "2024-9-7", completed_at: "2024-9-9", name: "#D3", status: "open", line_items: createLineItems(), order_id: "13243585", shipping_line: nil, tags: "", total_price: "100.00", customer: CurrentCustomer.signedUpCustomer.customer))
        customerDraftCart = customerDraftFav // Example: same draft for cart
    }
    
    func addDraftOrders() {
        guard let customerID = CurrentCustomer.signedUpCustomer.customer.id, customerID != 0 else {
            print("Cannot create draft order. Customer does not exist.")
            return
        }
        
        // Add draft order for favorites
        network?.Post(url: URLManager.getUrl(for: .draftOrder), type: customerDraftFav, completionHandler: { result, error in
            guard error == nil else {
                print("Error adding draft order for favorites: \(String(describing: error))")
                return
            }
            print("Draft order for favorites created: \(result)")
        })
        
        // Add draft order for cart
        network?.Post(url: URLManager.getUrl(for: .draftOrder), type: customerDraftCart, completionHandler: { result, error in
            guard error == nil else {
                print("Error adding draft cart: \(String(describing: error))")
                return
            }
            print("Draft order for cart created: \(result)")
        })
    }
                             	      
    func createLineItems() -> [LineItem] {
        // Sample line items
        return [LineItem(id: 1066630381, variant_id: 45726370201838, product_id: 8649736323310, title: "ADIDAS | CLASSIC BACKPACK", variant_title: "OS / black", vendor: "ADIDAS", quantity: 1, name: "ADIDAS | CLASSIC BACKPACK", custom: true, price: "70.00")]
    }
    
}
