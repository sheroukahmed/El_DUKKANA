//
//  SettingsViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var CurrencyList: UIButton!

    var SettingVM = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CurrentCustomer.currentCustomer.email == nil{
            self.signOutBtn.isHidden = true
        }
        print(CurrentCustomer.currentCustomer)
        view.backgroundColor = UIColor(named: "Color")

        // MARK: - Currency list
        let CurrencyItemAction = { (action: UIAction) in
             print(action.title)
        }
        var menuChildren: [UIMenuElement] = []
        for currency in SettingVM.Currencies {
            menuChildren.append(UIAction(title: currency, handler: CurrencyItemAction))
        }
        CurrencyList.menu = UIMenu(options: .displayInline, children: menuChildren)
        CurrencyList.showsMenuAsPrimaryAction = true
        CurrencyList.changesSelectionAsPrimaryAction = true
    
    }
    

   
    @IBAction func DarkSwitch(_ sender: UISwitch) {
        
        if #available(iOS 16.4, *){
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        for window in windowScene.windows {
                            window.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
                        }
                    }
        }else{
            
        }
    }
    
    @IBAction func signOutBtnAction(_ sender: Any) {
        CurrentCustomer.currentCustomer.email = ""
        let storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: nil)
        let signInVC = storyboard.instantiateViewController(identifier: "SignInVC") as! SignInVC
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.modalTransitionStyle = .crossDissolve
        signInVC.isFromSignOut = true
        present(signInVC, animated: true)
        
        
        
    }
    
  
    @IBAction func AboutUsbtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AboutUS", bundle: nil)
        if let about = storyboard.instantiateViewController(withIdentifier: "aboutUs") as? AboutUsViewController {
            about.title = "About Us"
            self.navigationController?.pushViewController(about, animated: true)
        }
    }
}

