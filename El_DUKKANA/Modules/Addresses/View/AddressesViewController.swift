//
//  AddressesViewController.swift
//  El_DUKKANA
//
//  Created by Sarah on 13/09/2024.
//

import UIKit

class AddressesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AddressesTableView: UITableView!
    @IBOutlet weak var noAddressImage: UIImageView!
    
    var addressesViewModel: AddressesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAddressesTableView()
        toggleNoDataView()
        
        addressesViewModel = AddressesViewModel()
        addressesViewModel?.getAllAddresses()
        addressesViewModel?.bindToAddresses = { [weak self] in
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
        return addressesViewModel?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddressesTableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressesTableViewCell
        
        let address = addressesViewModel?.addresses? [indexPath.row]
        
        cell.configureCell(firstAddress: address?.address1 ?? "", secondAddress: address?.address2 ?? "", cityy: address?.city ?? "", countryy: address?.country ?? "", zipp: address?.zip ?? "")
        
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    
    private func toggleNoDataView() {
            let noAddresses = addressesViewModel?.addresses?.isEmpty ?? true
            AddressesTableView.isHidden = noAddresses
            noAddressImage.isHidden = !noAddresses
    }
    
    @IBAction func addNewAddress(_ sender: Any) {
        if let address = self.storyboard?.instantiateViewController(withIdentifier: "addNewAddress") as? AddAddressViewController {
            address.title = "Add New Address"
            self.navigationController?.pushViewController(address, animated: true)
        }
    }
    
}
