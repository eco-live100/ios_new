//
//  SendMoneyToContactVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/06/21.
//

import UIKit
import SwiftyJSON

class SendMoneyToContactVC: UIViewController {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblAccountBalance: UILabel!
    @IBOutlet weak var txtContactEmail: PaddingTextField!
    @IBOutlet weak var txtAmount: PaddingTextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblPaymentFor: UILabel!
    @IBOutlet weak var imgRadioGoods: UIImageView!
    @IBOutlet weak var imgRadioCash: UIImageView!
    @IBOutlet weak var imgRadioGift: UIImageView!
    @IBOutlet weak var imgRadioOthers: UIImageView!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var lblCharacterLeft: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isFromQRScan:Bool = false
    var strPaymentFor = ""
    
    var objQRCodeUserDetail: UserDetail!
    var objContactDetail: EcoliveContact!
    var objWalletDetail = WalletObject.init([:])
    
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
        self.lblPaymentFor.attributedText = GlobalData.shared.convertStringtoAttributedText(strFirst: "Payment is for" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: self.lblPaymentFor.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "(what's this?)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: self.lblPaymentFor.font.pointSize - 4)!, strSecondColor: Constants.Color.THEME_YELLOW)
        
        self.imgRadioGoods.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCash.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioGift.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioOthers.image = UIImage.init(named: "radio_uncheck")
        
        self.txtNote.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 8)
        
        DispatchQueue.main.async {
            self.btnContinue.layer.cornerRadius = self.btnContinue.frame.height / 2.0
            self.btnContinue.createButtonShadow()
        }
        
        if self.isFromQRScan {
            self.txtContactEmail.text = self.objQRCodeUserDetail.email
        } else {
            //self.txtContactEmail.text = self.objContactDetail.contactEmail
        }
        
        self.txtContactEmail.isUserInteractionEnabled = false
        
        let numberOfChars = self.txtNote.text.length
        let remainingChars = 160 - numberOfChars
        
        self.lblCharacterLeft.text = "You have another <\(remainingChars)> characters left"
        
        self.callGetWalletBalance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWalletBalance), name: NSNotification.Name(rawValue: kUpdateWalletBalance), object: nil)
    }
    
    //MARK: - HELPER -
    
    @objc func updateWalletBalance() {
        self.callGetWalletBalance()
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPaymentGoodsClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.imgRadioGoods.image = UIImage.init(named: "radio_check")
        self.imgRadioCash.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioGift.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioOthers.image = UIImage.init(named: "radio_uncheck")
        
        self.strPaymentFor = "Goods"
    }
    
    @IBAction func btnPaymentCashClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.imgRadioGoods.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCash.image = UIImage.init(named: "radio_check")
        self.imgRadioGift.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioOthers.image = UIImage.init(named: "radio_uncheck")
        
        self.strPaymentFor = "CashAdvance"
    }
    
    @IBAction func btnGiftClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.imgRadioGoods.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCash.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioGift.image = UIImage.init(named: "radio_check")
        self.imgRadioOthers.image = UIImage.init(named: "radio_uncheck")
        
        self.strPaymentFor = "Gift"
    }
    
    @IBAction func btnOtherClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.imgRadioGoods.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCash.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioGift.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioOthers.image = UIImage.init(named: "radio_check")
        
        self.strPaymentFor = "Others"
    }
    
    @IBAction func btnContinueClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtContactEmail.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Contact email is required")
        }
        else if !self.txtContactEmail.isValidEmail() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Contact email is invalid")
        }
        else if self.txtAmount.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Amount is required")
        }
        else if self.strPaymentFor == "" {
            GlobalData.shared.showDarkStyleToastMesage(message: "Pyment purpose is required")
        }
        else {
            guard let inputValue = Double(self.txtAmount.text ?? "") else { return }
            
            if inputValue > self.objWalletDetail.wallet {
                GlobalData.shared.displayConfirmationAlert(self, title: "Insufficient Balance", message: "Would you like to add money in your wallet?", btnTitle1: "Cancel", btnTitle2: "Proceed", actionBlock: { (isConfirmed) in
                    if isConfirmed {
                        let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddMoneyVC") as! AddMoneyVC
                        controller.isFromCartPayment = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                })
            } else {
                self.btnContinue.isUserInteractionEnabled = false
                self.callWalletToWalletTransferAPI()
            }
        }
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension SendMoneyToContactVC: UITextFieldDelegate {
    
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
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.txtAmount {
//            guard let inputValue = Double(self.txtAmount.text ?? "") else { return }
//
//            if inputValue > self.objWalletDetail.wallet {
//                GlobalData.shared.showDarkStyleToastMesage(message: "Available balance is not enough")
//            }
//        }
//    }
}

//MARK: - UITEXTVIEW DELEGATE METHOD -

extension SendMoneyToContactVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.tintColor = UIColor.init(hex: 0x333333)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if numberOfChars <= 160 {
            let remainingChars = 160 - numberOfChars
            self.lblCharacterLeft.text = "You have another <\(remainingChars)> characters left"
        }
        
        return numberOfChars <= 160
    }
}

//MARK: - API CALL -

extension SendMoneyToContactVC {
    //GET WALLET BALANCE
    func callGetWalletBalance() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let params: [String:Any] = [:]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.WALLET_BALANCE, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            strongSelf.objWalletDetail = WalletObject.init(payload)
                            
                            strongSelf.lblAccountBalance.text = "$\(strongSelf.objWalletDetail.wallet)"
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //WALLET TO WALLET TRANSFER
    func callWalletToWalletTransferAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["amount"] = self.txtAmount.text ?? ""
        params["email"] = self.txtContactEmail.text ?? ""
        params["paymentFor"] = self.strPaymentFor
        params["paymentNote"] = self.txtNote.text ?? ""
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.TRANSFER_TO_WALLET, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        strongSelf.btnContinue.isUserInteractionEnabled = true
                        
                        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                        controller.isFromCart = false
                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnContinue.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        strongSelf.btnContinue.isUserInteractionEnabled = true
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnContinue.isUserInteractionEnabled = true
        }
    }
}
