//
//  InsuranceVC.swift
//  EcoLive
//
//  Created by sunil biloniya on 05/11/22.
//

import UIKit

class InsuranceVC: UIViewController {
    @IBOutlet weak var btnContinue: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnContinue.layer.cornerRadius = self.btnContinue.frame.height / 2.0
        self.btnContinue.createButtonShadow()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinueClick(_ sender: UIButton) {
        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "MedecationsVC") as! MedecationsVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btnHelpClick(_ sender: UIButton) {
        guard let url = URL(string: "https://www.ecommercepartners.net/content/contact-us") else { return }
        UIApplication.shared.open(url)
        
    }

}
