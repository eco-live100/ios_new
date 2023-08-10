//
//  SwicthRiderVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class SwicthRiderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backbtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnallAction(_ sender: UIButton) {

        if sender.tag == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDestinationVC") as! ChooseDestinationVC
            self.navigationController?.pushViewController(vc, animated: true)

        }

        if sender.tag == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStopVC") as! AddStopVC
            self.navigationController?.pushViewController(vc, animated: true)

        }


        
    }
}
