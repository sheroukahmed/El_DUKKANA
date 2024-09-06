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
    let Adsimages: [UIImage] = [
        UIImage(named: "cup30")!,
        UIImage(named: "cup40")!,
        UIImage(named: "cup50")!,
        UIImage(named: "Untitled design10")!,
        UIImage(named: "Untitled design111")!
    ]

    @IBOutlet weak var cuponImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
