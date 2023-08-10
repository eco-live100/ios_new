//

//
//  Created by MacBook Air on 26/10/22.
//

import UIKit

protocol paymentMethodDelegate {
    func navToPayemnt()
}

class PayInvoicePopUp_VC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var mainV : UIView!
    @IBOutlet var crossbtnView : UIView!
    @IBOutlet var bottomBlue_view : UIView!
    @IBOutlet var paybtnView : UIView!
    @IBOutlet var textViews : [UIView]!
    
    var delegate : paymentMethodDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paybtnView.layer.cornerRadius = paybtnView.frame.height/2
        crossbtnView.layer.cornerRadius = 5
        crossbtnView.layer.masksToBounds = false
        crossbtnView.layer.shadowColor = UIColor.lightGray.cgColor
        crossbtnView.layer.shadowOpacity = 0.3
        crossbtnView.layer.shadowOffset = CGSize(width: -1, height: 1)
        crossbtnView.layer.shadowRadius = 0.7
        bottomBlue_view.layer.cornerRadius = 22
        bottomBlue_view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        mainV.layer.cornerRadius = 22
        for view in textViews {
            view.layer.cornerRadius = 25.0
            view.layer.cornerRadius = view.frame.height/2
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 0.7
        }
        
        
    }
    //MARK: - Action
    @IBAction func btnProceedTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.delegate?.navToPayemnt()
    }
    
    @IBAction func btnbckPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
