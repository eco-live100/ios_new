//
//  SendMoneyToBankVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 22/06/21.
//

import UIKit
import SwiftValidators
import SwiftyJSON

class SendMoneyToBankVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var txtAccName: ACFloatingTextfield!
    @IBOutlet weak var txtAccNumber: ACFloatingTextfield!
    @IBOutlet weak var txtRouting: ACFloatingTextfield!
    @IBOutlet weak var txtAmount: ACFloatingTextfield!
    @IBOutlet weak var btnProceed: UIButton!
    
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
        DispatchQueue.main.async {
            self.btnProceed.layer.cornerRadius = self.btnProceed.frame.height / 2.0
            self.btnProceed.createButtonShadow()
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProceedClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let amount = self.txtAmount.text ?? ""
        var amountValue:Double = 0.0
        amountValue = (amount as NSString).doubleValue
        
        if self.txtAccName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Account holder name is required")
        }
        else if self.txtAccNumber.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Account number is required")
        }
        else if self.txtRouting.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Routing number is required")
        }
        else if self.txtAmount.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Amount is required")
        }
        else if amountValue < 50 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Amount should be minimum 50")
        }
        else {
            self.btnProceed.isUserInteractionEnabled = false
            self.callTransferToBankAPI()
        }
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension SendMoneyToBankVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        let text: NSString = textField.text! as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        if textField == self.txtAmount {
            let textArray = resultString.components(separatedBy: ".")
            
            if textArray.count == 2 {
                let lastString = textArray.last
                if lastString!.count > 2 { //Check number of decimal places
                    return false
                }
            }
            if textArray.count > 2 { //Allow only one "."
                return false
            }
        }
        
        return true
    }
}

//MARK: - API CALL -

extension SendMoneyToBankVC {
    //BANK TRANSFER
    func callTransferToBankAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["account_holder_name"] = self.txtAccName.text ?? ""
        params["Account_number"] = self.txtAccNumber.text ?? ""
        params["Routing_number"] = self.txtRouting.text ?? ""
        params["amount"] = self.txtAmount.text ?? ""
        params["transaction_from"] = "card"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.TRANSFER_TO_BANK, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        strongSelf.btnProceed.isUserInteractionEnabled = true
                        
                        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                        controller.isFromCart = false
                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnProceed.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        strongSelf.btnProceed.isUserInteractionEnabled = true
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnProceed.isUserInteractionEnabled = true
        }
    }
}
