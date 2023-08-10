//
//  ScheduleRideVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class ScheduleRideVC: UIViewController {
    
    @IBOutlet var tblView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.register(UINib(nibName: "ScheduleSearchTVCell", bundle: nil), forCellReuseIdentifier: "ScheduleSearchTVCell")
        tblView.register(UINib(nibName: "ScheduleDateTVCell", bundle: nil), forCellReuseIdentifier: "ScheduleDateTVCell")
        
    }
    

    // MARK: - Navigation

     @IBAction func backbtnAction(_ sender: Any) {
         TaxiTabbarObj.selectedIndex = 0
     }

}
extension ScheduleRideVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tblView.dequeueReusableCell(withIdentifier: "ScheduleSearchTVCell") as! ScheduleSearchTVCell
            cell.plusbtn.addTarget(self, action: #selector(switchRider(_:)), for: .touchUpInside)
          
            return cell
        case 1:
            let cell = tblView.dequeueReusableCell(withIdentifier: "ScheduleDateTVCell") as! ScheduleDateTVCell
            cell.confirmbtn.addTarget(self, action: #selector(confirmBtnTapped(_:)), for: .touchUpInside)
            cell.vc = self
            return cell
        
        default:
            print("No section found for this row")
            return UITableViewCell()
        }
    }
    @objc func switchRider(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStopVC") as! AddStopVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func confirmBtnTapped(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentOptionsVC") as! PaymentOptionsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
    
