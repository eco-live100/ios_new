//
//  RiderProductDetailViewController.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 22/06/22.
//

import UIKit

class RiderProductDetailViewController: UIViewController {
    
    static func getObject()-> RiderProductDetailViewController {
        let storyboard = UIStoryboard(name: "Rider", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RiderProductDetailViewController") as? RiderProductDetailViewController
        if let vc = vc {
            return vc
        }
        return RiderProductDetailViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
