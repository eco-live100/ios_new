//
//  ViewController.swift
//  DemoApp
//
//  Created by Ishan Jha on 08/11/22.
//

import UIKit

class Prescribed_Medication: UIViewController {
    
    @IBOutlet var headerView : UIView!
    @IBOutlet var tblView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "PreciptionTVCell", bundle: nil), forCellReuseIdentifier: "PreciptionTVCell")
        tblView.register(UINib(nibName: "MedicationTVCell", bundle: nil), forCellReuseIdentifier: "MedicationTVCell")
        tblView.register(UINib(nibName: "PreciptionFooterTVCell", bundle: nil), forCellReuseIdentifier: "PreciptionFooterTVCell")
        
        
        // Do any additional setup after loading the view.
    }
}


//MARK: - TableView Delegate


extension Prescribed_Medication : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            
            return 1
        }
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        switch indexPath.section {
            
        case 0:
            
            let cell = tblView.dequeueReusableCell(withIdentifier: "PreciptionTVCell") as! PreciptionTVCell
           
            return cell
            
        case 1:
            let cell = tblView.dequeueReusableCell(withIdentifier: "MedicationTVCell") as! MedicationTVCell
            
            if indexPath.row == 0{
                cell.mainView.backgroundColor = UIColor(named: "medicationCellclr")
            }else{
                cell.mainView.backgroundColor = UIColor(named: "additionalCellColor")
            }
            
            return cell
        case 2:
            let cell = tblView.dequeueReusableCell(withIdentifier: "PreciptionFooterTVCell") as! PreciptionFooterTVCell
            
            
            return cell
        default:
            print("No section found for this row")
            return UITableViewCell()
        }
    
    }
   
}
