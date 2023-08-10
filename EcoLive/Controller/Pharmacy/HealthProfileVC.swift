//
//  HealthProfileVC.swift
//  EcoLive
//
//  Created by sunil biloniya on 04/11/22.
//

import UIKit

class HealthProfileVC: UIViewController {
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewSSN: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.viewName.layer.cornerRadius = self.viewName.frame.height / 2.0
            self.viewName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewName.layer.borderWidth = 1.0
            
            self.viewAddress.layer.cornerRadius = self.viewAddress.frame.height / 2.0
            self.viewAddress.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewAddress.layer.borderWidth = 1.0
            
            self.viewSSN.layer.cornerRadius = self.viewSSN.frame.height / 2.0
            self.viewSSN.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewSSN.layer.borderWidth = 1.0
            self.btnContinue.layer.cornerRadius = self.btnContinue.frame.height / 2.0
            self.btnContinue.createButtonShadow()
        }
        
        

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinueClick(_ sender: UIButton) {
        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "InsuranceVC") as! InsuranceVC
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
