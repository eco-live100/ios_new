//
//  ContactDetailVC.swift
//  LancerT
//
//  Created by MacBook Air on 31/10/22.
//

import UIKit

class ContactDetailVC: UIViewController {

    @IBOutlet weak var view_message: UIView!
    @IBOutlet weak var view_ecolive: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_message.layer.cornerRadius = view_message.frame.height/2
        view_ecolive.layer.cornerRadius = view_ecolive.frame.height/2
    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
