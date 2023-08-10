//
//  WalletVC.swift
//  EcoLive
//
//  Created by Emizen tech iMac  on 07/06/22.
//

import UIKit

class WalletVC: BaseVC {
        
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    func initData() {
    
        DispatchQueue.main.async {
            self.imageUser.layer.cornerRadius = (self.imageUser.layer.frame.size.height / 2)
            self.imageUser.clipsToBounds = true
            self.bgView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        }
        
    }
    
    // MARK: - ACTIONS -
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func btnAddMoneyClick(_ sender: UIButton) {
        
    }
    
}
