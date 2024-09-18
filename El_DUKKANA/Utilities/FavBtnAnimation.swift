//
//  FavBtnAnimation.swift
//  El_DUKKANA
//
//  Created by ios on 14/09/2024.
//

import Foundation
import UIKit

class FavBtnAnimation{
    // Set favourite button
    func setFavouriteButton(btn: UIButton) {
        btn.layer.shadowColor = UIColor.red.cgColor
        btn.layer.shadowRadius = 0
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowOffset = CGSize.zero
        btn.layer.masksToBounds = false
    }
    
    // Add pulsating animation
    func addPulsatingAnimation(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.25
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .zero
        view.layer.add(pulseAnimation, forKey: "pulse")
        
        // Add animation to make the glow pulsate
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = 8
        glowAnimation.duration = 1.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .zero
        
        view.layer.add(glowAnimation, forKey: "glowAnimation")
    }
}
