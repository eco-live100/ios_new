//
//  HealthPopUpVC.swift
//  EcoLive
//
//  Created by sunil biloniya on 05/11/22.
//

import UIKit

class HealthPopUpVC: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    var callback : (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnOk.layer.cornerRadius = self.btnOk.frame.height / 2.0
        self.btnOk.createButtonShadow()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGoBackClick(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    @IBAction func btnOkayTapAction(_ sender: UIButton) {
        self.dismiss(animated: false)
        callback!()
    }


}


extension UIView {
    
    public func isAnimate(_ vc: UIViewController) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
            vc.view.backgroundColor = UIColor.init(hexString: "000000", alpha: 0.70)
        }, completion: nil)
    }
}
