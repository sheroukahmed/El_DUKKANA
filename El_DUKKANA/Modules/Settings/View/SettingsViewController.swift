//
//  SettingsViewController.swift
//  El_DUKKANA
//
//  Created by  sherouk ahmed  on 10/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var CurrencyList: UIButton!

    let Currencies = ["EGP","USD","EUR"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let actionClosure = { (action: UIAction) in
             print(action.title)
        }
        
        let button = UIButton(primaryAction: nil)


        var menuChildren: [UIMenuElement] = []
        for currency in Currencies {
            menuChildren.append(UIAction(title: currency, handler: actionClosure))
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
            let appDelegate = UIApplication.shared.windows.first
            
            if sender.isOn {
                appDelegate?.overrideUserInterfaceStyle = .dark
                return
            }
            appDelegate?.overrideUserInterfaceStyle = .light
            return
            
        }else{
            
        }
    }
    
    @IBAction func AboutUsbtn(_ sender: Any) {
    }
}
