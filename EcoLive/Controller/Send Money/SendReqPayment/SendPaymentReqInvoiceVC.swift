//
//  SendPaymentReqInvoiceVC.swift
//  EcoLive
//
//  Created by  on 26/10/22.
//

import UIKit

class SendPaymentReqInvoiceVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelectContect(_ sender: UIButton) {

        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "FriendListEcolive") as! FriendListEcolive

        controller.titleVC = ""
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func btnSendInvoice(_ sender: UIButton) {

        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PayInvoicePopUp_VC") as! PayInvoicePopUp_VC
        controller.delegate = self
        controller.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.present(controller, animated: true, completion: nil)

    }

}

extension SendPaymentReqInvoiceVC : paymentMethodDelegate {

    func navToPayemnt() {
        let vc = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


