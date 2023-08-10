//
//  PaymentOptionsVC.swift
//  DemoApp
//
//  Created by Ishan Jha on 11/11/22.
//

import UIKit

class PaymentOptionsVC: UIViewController {
    
    @IBOutlet var personalbtn : UIButton!
    @IBOutlet var businessbtn : UIButton!
    @IBOutlet var cashView : UIView!
    @IBOutlet var uberCashView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        personalbtn.layer.cornerRadius = personalbtn.frame.height / 2
        businessbtn.layer.cornerRadius = businessbtn.frame.height / 2
        cashView.dropShadowToCollC()
        uberCashView.dropShadowToCollC()
    }
// MARK: - Navigation


      @IBAction func backbtnAction(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
      }

    @IBAction func nextbtnAction(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetDestinationVC") as! SetDestinationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @IBAction func personalClick(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentRequestVC") as! PaymentRequestVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
}
