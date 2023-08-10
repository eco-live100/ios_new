//
//  PaymentMethodVC.swift
//  
//
//  Created by apple on 26/10/22.
//

import UIKit

class PaymentMethodVC: UIViewController {
    @IBOutlet var tblView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(UINib(nibName: "WalletOptionTVCell", bundle: nil), forCellReuseIdentifier: "WalletOptionTVCell")
        tblView.register(UINib(nibName: "AddMethodTVCell", bundle: nil), forCellReuseIdentifier: "AddMethodTVCell")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
}
//MARK: TableView Delegate
extension PaymentMethodVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return 2
        }
        if section == 1{
            
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
            
        case 0:
            let cell = tblView.dequeueReusableCell(withIdentifier: "WalletOptionTVCell") as! WalletOptionTVCell
            
            return cell
            
        case 1:
            let cell = tblView.dequeueReusableCell(withIdentifier: "AddMethodTVCell") as! AddMethodTVCell
            
            return cell
        default:
            print("No section found for this row")
            return UITableViewCell()
        }
    }
}
