//
//  OnBoardingViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 11/09/2024.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var screen1View: UIView!
    @IBOutlet weak var screen2View: UIView!
    @IBOutlet weak var screen3View: UIView!
    
    @IBOutlet weak var next1: UIButton!
    @IBOutlet weak var next2: UIButton!
    @IBOutlet weak var getStarted3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        next1.layer.cornerRadius = 20
        next2.layer.cornerRadius = 20
        getStarted3.layer.cornerRadius = 20
        
        showScreen1()
    }
    
    func showScreen1() {
        screen1View?.isHidden = false
        screen2View?.isHidden = true
        screen3View?.isHidden = true
    }
    
    func showScreen2() {
        screen1View?.isHidden = true
        screen2View?.isHidden = false
        screen3View?.isHidden = true
    }
    
    func showScreen3() {
        screen1View?.isHidden = true
        screen2View?.isHidden = true
        screen3View?.isHidden = false
    }
    
    
    @IBAction func nextFromScreen1(_ sender: Any) {
        showScreen2()
    }
    
    @IBAction func nextFromScreen2(_ sender: Any) {
        showScreen3()
    }
   
    @IBAction func getStarted(_ sender: Any) {
        goToHome()
    }
    
    
    @IBAction func skip(_ sender: Any) {
        goToHome()
    }
    
    @IBAction func backFromScreen3(_ sender: Any) {
        showScreen2()
    }
    
    @IBAction func backFromScreen2(_ sender: Any) {
        showScreen1()
    }
    
    
    private func goToHome() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        let storyboard = UIStoryboard(name: "StartOptionsStoryboard", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(identifier: "StartOptions")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = homeViewController
                window.makeKeyAndVisible()
            }
        }
    }
}
