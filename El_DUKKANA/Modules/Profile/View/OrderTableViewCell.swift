//
//  OrderTableViewCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 12/09/2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var noOfItems: UILabel!
    @IBOutlet weak var moneyPaid: UILabel!
    @IBOutlet weak var orderCurrency: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell (order: String, orderNoOfItems: Int, orderPrice: String, currency: String, date: String) {
        orderNo.text = order
        noOfItems.text = "\(orderNoOfItems)"
        moneyPaid.text = orderPrice
        orderCurrency.text = currency
        orderDate.text = date
    }
}
