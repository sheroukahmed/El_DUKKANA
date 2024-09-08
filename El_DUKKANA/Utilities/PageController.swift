//
//  PageController.swift
//  El_DUKKANA
//
//  Created by ios on 08/09/2024.
//

import Foundation
import UIKit

class PageController{
    var currentCellIndex = 0
     func moveNextIndex(specificCount : Int, specificCollectionView: UICollectionView, pageController: UIPageControl){
        if currentCellIndex < (specificCount) - 1 {
            currentCellIndex += 1
        }
        else {
            currentCellIndex = 0
        }
        specificCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageController.currentPage = currentCellIndex
    }
}
