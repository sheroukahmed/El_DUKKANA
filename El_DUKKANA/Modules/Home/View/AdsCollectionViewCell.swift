//
//  AdsCollectionViewCell.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 06/09/2024.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {
    
    static func nib()->UINib{
        return UINib(nibName: "AdsCollectionViewCell", bundle: nil)
    }
    

    @IBOutlet weak var cuponImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
