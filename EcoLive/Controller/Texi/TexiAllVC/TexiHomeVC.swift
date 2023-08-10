//
//  TexiHomeVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class TexiHomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.register(UINib(nibName: "TexiSearchTVCell", bundle: nil), forCellReuseIdentifier: "TexiSearchTVCell")
    }
}
//MARK: - TableView Delegate


extension TexiHomeVC {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tblView.dequeueReusableCell(withIdentifier: "ImageSlideTVCell") as! ImageSlideTVCell

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnHomeBringe(_:)))
//            cell.slideCollectionV..isUserInteractionEnabled = true
            //cell.lblBringMeHome.addGestureRecognizer(tap)

            return cell
        case 1:
            let cell = tblView.dequeueReusableCell(withIdentifier: "TexiSearchTVCell") as! TexiSearchTVCell
            
            cell.searchbtn.addTarget(self, action: #selector(switchRider(_:)), for: .touchUpInside)
            cell.savedbtn.addTarget(self, action: #selector(savedbtnTapped(_:)), for: .touchUpInside)
            cell.btnTapNow.addTarget(self, action: #selector(nowbtnTapped(_:)), for: .touchUpInside)
            cell.destinationbtn.addTarget(self, action: #selector(destinationdbtnTapped(_:)), for: .touchUpInside)
            return cell
        
        default:
            print("No section found for this row")
            return UITableViewCell()
        }
        
        
    }

    @objc func handleTapOnHomeBringe(_ sender: UITapGestureRecognizer? = nil) {

    }

    @objc func switchRider(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SwicthRiderVC") as! SwicthRiderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func savedbtnTapped(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDestinationVC") as! ChooseDestinationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func nowbtnTapped(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleRideTimeVC") as! ScheduleRideTimeVC
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func destinationdbtnTapped(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetDestinationOnMapVC") as! SetDestinationOnMapVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 130
//        }else{
//            return 200
//        }
//       
//    }
   
}
