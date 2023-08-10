//
//  VehiclesPollutionColorPoupVC.swift
//  EcoLive
//
//  Created by  on 20/11/22.
//

import UIKit

class VehiclesPollutionColorPoupVC: UIViewController {

    static func getObject()-> VehiclesPollutionColorPoupVC {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VehiclesPollutionColorPoupVC") as? VehiclesPollutionColorPoupVC
        if let vc = vc {
            return vc
        }
        return VehiclesPollutionColorPoupVC()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func actionOkayButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }

}
