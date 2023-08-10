//
//  imageProfileVC.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 26/05/22.
//

import UIKit

class imageProfileVC: BaseVC {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
}
