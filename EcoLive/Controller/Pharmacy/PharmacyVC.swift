//
//  PharmacyVC.swift
//  EcoLive
//
//  Created by sunil biloniya on 04/11/22.
//

import UIKit

class PharmacyVC: UIViewController {
    

    @IBOutlet weak var btnNext: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.btnNext.layer.cornerRadius = self.btnNext.frame.height / 2.0
        self.btnNext.createButtonShadow()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSkipClick(_ sender: UIButton) {
        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "HealthPopUpVC") as! HealthPopUpVC
        controller.modalPresentationStyle = .overFullScreen
        controller.callback = {
            let controller = FoodAndGroceryCategoryVC.getObject()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        self.present(controller, animated: false) {
            controller.view.isAnimate(controller)
        }
    }
    @IBAction func btnNextClick(_ sender: UIButton) {
        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "HealthProfileVC") as! HealthProfileVC
        self.navigationController?.pushViewController(controller, animated: true)

    }

    @IBAction func btnHelpClick(_ sender: UIButton) {
        guard let url = URL(string: "https://www.ecommercepartners.net/content/contact-us") else { return }
        UIApplication.shared.open(url)
        
    }
}
