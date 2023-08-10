//
//  PHSignUpIntro.swift
//  EcoLive
//
//  Created by  on 05/11/22.
//

import UIKit

class PHSignUpIntro: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnGoBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAllAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:

            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "FriendListEcolive") as! FriendListEcolive
            controller.isFrome = "pharmacy"
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 2:
            
                    let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "RequestSentVC") as! RequestSentVC
                    self.navigationController?.pushViewController(controller, animated: true)

//            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "Prescribed_Medication") as! Prescribed_Medication
//            self.navigationController?.pushViewController(controller, animated: true)
//            break

//            let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "MedicalPrecriptionVC") as! MedicalPrecriptionVC
//            self.navigationController?.pushViewController(controller, animated: true)
//            break
            
            break
        case 3:
            let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PHOrderVC") as! PHOrderVC
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 4:
            break
        default:
            break
        }
    }

    @IBAction func btnHelpClick(_ sender: UIButton) {
        guard let url = URL(string: "https://www.ecommercepartners.net/content/contact-us") else { return }
        UIApplication.shared.open(url)
    }

}
