class OrdersViewModel {
    
    var network: NetworkProtocol?
    var bindToOrders: (() -> Void) = {}
    var orders: [Order]? {
        didSet {
            bindToOrders()
        }
    }
    
    init() {
        network = NetworkManager()
        orders = []  // Initialize orders as an empty array
    }
    
    func getAllOrders() {
        let url = URLManager.getUrl(for: .orders)
        print("URL: \(url)")
        network?.fetch(url: url, type: OrderResponse.self, completionHandler: { [weak self] result, error in
            guard let result = result else {
                print("Error in fetching the data : \(error)")
                return
            }
            for item in result.orders {
                print(item.email!)
                if item.email == CurrentCustomer.currentCustomer.email {
                    print("Oooooooooooo:\(item)")
                    self?.orders?.append(item)  // Append to the initialized array
                    print(self?.orders)
                }
            }
        })
    }
}
