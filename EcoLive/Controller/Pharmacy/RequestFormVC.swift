//
//  RequestFormVC.swift
//  EcoLive
//
//  Created by sunil biloniya on 08/11/22.
//

import UIKit

class RequestFormVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
