//
//  ChooseDestinationVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 10/11/22.
//

import UIKit

class ChooseDestinationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Navigation

     @IBAction func backbtnAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }


    @IBAction func menuTapped(_ sender: Any) {

    }

    @IBAction func btnSelectSaveAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveLocationVC") as! SaveLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
