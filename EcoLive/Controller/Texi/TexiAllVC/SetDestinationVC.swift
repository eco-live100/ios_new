//
//  SetDestinationVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 11/11/22.
//

import UIKit

class SetDestinationVC: UIViewController {
    
    @IBOutlet var tblView : UITableView!
    @IBOutlet var carView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(UINib(nibName: "MapViewTVCell", bundle: nil), forCellReuseIdentifier: "MapViewTVCell")
        tblView.register(UINib(nibName: "VehicleSelectTVCell", bundle: nil), forCellReuseIdentifier: "VehicleSelectTVCell")
        carView.layer.borderWidth = 1.5
        carView.layer.borderColor = UIColor.black.cgColor
        
        
        // Do any additional setup after loading the view.
    }
}

//MARK: - TableView Delegate
 
extension SetDestinationVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tblView.dequeueReusableCell(withIdentifier: "MapViewTVCell") as! MapViewTVCell
          
            return cell
        case 1:
            let cell = tblView.dequeueReusableCell(withIdentifier: "VehicleSelectTVCell") as! VehicleSelectTVCell
          
            return cell
        
        default:
            print("No section found for this row")
            return UITableViewCell()
        }
        
        
    }
   
}
