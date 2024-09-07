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
    
    
    @IBOutlet weak var itemprice: UILabel!
    
    @IBOutlet weak var itemQuantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
