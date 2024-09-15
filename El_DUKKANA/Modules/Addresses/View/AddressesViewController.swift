//
//  AddressesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 13/09/2024.
//

import UIKit

class AddressesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, AddressDelegateProtocol {
    
    
    
    @IBOutlet weak var AddressesTableView: UITableView!
    @IBOutlet weak var noAddressImage: UIImageView!
    
    var addressesViewModel = AddressesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAddressesTableView()
        toggleNoDataView()
        
         
        addressesViewModel.getAllAddresses()
        addressesViewModel.bindToAddresses = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.AddressesTableView.reloadData()
                self.toggleNoDataView()
            }
        }
       
    }
    
    func setUpAddressesTableView() {
        AddressesTableView.delegate = self
        AddressesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentCustomer.customerAdresses.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddressesTableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressesTableViewCell
        
        let address = CurrentCustomer.customerAdresses.addresses[indexPath.row]
        
        cell.configureCell(firstAddress: address.address1 ?? "", secondAddress: address.address2 ?? "", cityy: address.city ?? "", countryy: address.country ?? "", zipp: address.zip ?? "")
        
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    
    private func toggleNoDataView() {
        let noAddresses = CurrentCustomer.customerAdresses.addresses.isEmpty 
            AddressesTableView.isHidden = noAddresses
            noAddressImage.isHidden = !noAddresses
    }
    
    @IBAction func addNewAddress(_ sender: Any) {
        if let address = self.storyboard?.instantiateViewController(withIdentifier: "addNewAddress") as? AddAddressViewController {
            address.title = "Add New Address"
            address.delegate = self
            self.navigationController?.pushViewController(address, animated: true)
        }
    }
    func didAddAddress() {
        addressesViewModel.getAllAddresses()
        addressesViewModel.bindToAddresses = {
            self.AddressesTableView.reloadData()

        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Confirm Delete", message: "Do you want to delete this Address from your account?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                
                print(CurrentCustomer.customerAdresses.addresses.count)
                self.addressesViewModel.deleteAddresses(addressId: CurrentCustomer.customerAdresses.addresses[indexPath.row].id ?? 0)
                CurrentCustomer.customerAdresses.addresses.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
                print(CurrentCustomer.customerAdresses.addresses.count)
                
                
                
                //                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
                //                        self.addressesViewModel.getAllAddresses()
                //                        tableView.reloadData()
                //                    }}
            }
                
                
                let no = UIAlertAction(title: "No", style: .cancel)
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true)
            }
        }
        
}
