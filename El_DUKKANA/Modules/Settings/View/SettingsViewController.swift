//
//  SettingsViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var darkModeView: UIView!
    @IBOutlet weak var aboutUsBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var CurrencyList: UIButton!
    var SettingVM = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        if CurrentCustomer.currentCustomer.email == nil{
            self.signOutBtn.isHidden = true
        }
        print(CurrentCustomer.currentCustomer)
        view.backgroundColor = UIColor(named: "Color 1")

        // MARK: - Currency list
        
        let savedCurrency = UserDefaults.standard.string(forKey: "SelectedCurrency") ?? "USD"
        SettingVM.selectedCurrency = savedCurrency
        updateCurrencyLabel()

        
        let CurrencyItemAction = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            let selectedCurrency = action.title
            self.SettingVM.selectedCurrency = selectedCurrency
            UserDefaults.standard.set(selectedCurrency, forKey: "SelectedCurrency")
            self.updateCurrencyLabel()
            print(action.title)
        }
        
        var menuChildren: [UIMenuElement] = []
        for currency in SettingVM.Currencies {
            let action = UIAction(title: currency, state: currency == SettingVM.selectedCurrency ? .on : .off, handler: CurrencyItemAction)
            menuChildren.append(action)
        }
        CurrencyList.menu = UIMenu(options: .displayInline, children: menuChildren)
        CurrencyList.showsMenuAsPrimaryAction = true
        CurrencyList.changesSelectionAsPrimaryAction = true
        updateCurrencyLabel()
    }
    
    func setupUI() {
        currencyView.layer.cornerRadius = 15
        darkModeView.layer.cornerRadius = 15
        signOutBtn.layer.cornerRadius = 15
        aboutUsBtn.layer.cornerRadius = 15
    }
    
    func updateCurrencyLabel() {
        CurrencyList.setTitle(SettingVM.selectedCurrency, for: .normal)
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

