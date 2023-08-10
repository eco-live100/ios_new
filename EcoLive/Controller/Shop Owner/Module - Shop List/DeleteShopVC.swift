//
//  DeleteShopVC.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 21/07/22.
//

import UIKit

class DeleteShopVC: UIViewController {
    
    static func getObject()-> DeleteShopVC {
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeleteShopVC") as? DeleteShopVC
        if let vc = vc {
            return vc
        }
        return DeleteShopVC()
    }
    
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var viewFooter: UIView!
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewFooter.roundCorners(corners: [.topLeft , .topRight ], radius: 15.0)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ACTIONS
    @IBAction func actionOuterClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
