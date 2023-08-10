//
//  PharmacyMenuVC.swift
//  EcoLive
//
//  Created by Sumit Sharma on 28/02/23.
//

import UIKit

class PharmacyMenuVC: UIViewController {

    @IBOutlet weak var btnHospital: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnHospital.titleLabel?.numberOfLines = 0
        btnhospital.titleLabel.textAlignment = .center
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func hospitalProfileClicked(_ sender: UIButton) {
        
    }
    @IBAction func healthProfileClicked(_ sender: UIButton) {
                        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PharmacyVC") as! PharmacyVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func allMedicationClicked(_ sender: UIButton) {
        
    }
    @IBAction func allHospitalPharmacyClicked(_ sender: UIButton) {
        
    }

}
