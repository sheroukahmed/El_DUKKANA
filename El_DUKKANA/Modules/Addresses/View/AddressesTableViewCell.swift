//
//  AddressesTableViewCell.swift
//  El_DUKKANA
//
//  Created by Sarah on 14/09/2024.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var zip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell (firstAddress: String, secondAddress: String, cityy: String, countryy: String, zipp: String) {
        address1.text = firstAddress
        address2.text = secondAddress
        city.text = cityy
        country.text = countryy
        zip.text = zipp
    }
    

}
