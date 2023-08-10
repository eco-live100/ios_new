//
//  PHOrderVC.swift
//  EcoLive
//
//  Created by  on 05/11/22.
//

import UIKit

class PHOrderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnGoBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnHelpClick(_ sender: UIButton) {
        guard let url = URL(string: "https://www.ecommercepartners.net/content/contact-us") else { return }
        UIApplication.shared.open(url)
    }

}
