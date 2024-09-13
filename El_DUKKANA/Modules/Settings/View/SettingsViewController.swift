//
//  SettingsViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var CurrencyList: UIButton!

    var SettingVM = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    
  
    @IBAction func AboutUsbtn(_ sender: Any) {
    }
}

