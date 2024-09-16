//
//  CartItemTableViewCell.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 06/09/2024.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemimg: UIImageView!
    
    @IBOutlet weak var itemname: UILabel!
    
    @IBOutlet weak var itemColor: UILabel!
    @IBOutlet weak var itemprice: UILabel!
    @IBOutlet weak var itemCurrency: UILabel!
    
    @IBOutlet weak var availableQuantity: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    
    @IBOutlet weak var decreaseButton: UIButton!
    
    @IBOutlet weak var increaseButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusQuantity(_ sender: Any) {
        itemQuantity.text = String((Int(itemQuantity.text!))! - 1)
        if Int(itemQuantity.text!)! == 1 {
            decreaseButton.isEnabled = false
            decreaseButton.alpha = 0.25
        }
        if Int(itemQuantity.text!)! < Int(availableQuantity.text!)! {
            increaseButton.isEnabled = true
            increaseButton.alpha = 1.0
        }
    
        
    }
    @IBAction func plusQuantity(_ sender: Any) {
        itemQuantity.text = String((Int(itemQuantity.text!))! + 1)
        if Int(itemQuantity.text!)! > 1 {
            decreaseButton.isEnabled = true
            decreaseButton.alpha = 1.0
        }
        if Int(itemQuantity.text!)! == Int(availableQuantity.text!)! {
            increaseButton.isEnabled = false
            increaseButton.alpha = 0.25
        }
    }
}
