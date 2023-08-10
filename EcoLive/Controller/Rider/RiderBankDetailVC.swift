//
//  RiderBankDetailVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 17/06/21.
//

import UIKit

class RiderBankDetailVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgRider: UIImageView!
    @IBOutlet weak var lblRiderName: UILabel!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtAccountNo: UITextField!
    @IBOutlet weak var txtIFSC: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
        
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.viewContent.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        
        DispatchQueue.main.async {
            self.viewContent.addTopShadow()
            
            self.btnAdd.layer.cornerRadius = self.btnAdd.frame.height / 2.0
            self.btnAdd.createButtonShadow()
        }
        
        self.imgRider.image = UIImage.init(named: "user_placeholder")
        self.lblRiderName.text = "John Doe"
        self.lblWalletBalance.text = "$ 15,378"
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtBankName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Bank name is required")
        }
        else if self.txtAccountName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Account holder name is required")
        }
        else if self.txtAccountNo.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Account number is required")
        }
        else if self.txtIFSC.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "IFSC code is required")
        }
        else {
            debugPrint("Add Bank Detail")
        }
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension RiderBankDetailVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        } else if string == " " {
            if textField == self.txtAccountNo || textField == self.txtIFSC {
                return false
            }
        }
        return true
    }
}
