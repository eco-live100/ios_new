//
//  AddCardPopupVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 15/09/21.
//

import UIKit
import SwiftyJSON

class AddCardPopupVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
            
    @IBOutlet weak var viewDebitCard: UIView!
    @IBOutlet weak var viewLineDebit: UIView!
    @IBOutlet weak var imgRadioDebit: UIImageView!
    @IBOutlet weak var txtDebitCardNo: NoPopUpTextField!
    @IBOutlet weak var txtDebitExpiryDate: NoPopUpTextField!
    @IBOutlet weak var txtDebitCVV: NoPopUpTextField!
    
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewLineCredit: UIView!
    @IBOutlet weak var imgRadioCredit: UIImageView!
    @IBOutlet weak var txtCreditCardNo: NoPopUpTextField!
    @IBOutlet weak var txtCreditExpiryDate: NoPopUpTextField!
    @IBOutlet weak var txtCreditCVV: NoPopUpTextField!
    
    @IBOutlet weak var btnAddCard: UIButton!
    
    var isFromEdit:Bool = false
    var strPaymentType = ""

    let maxCardNumber = 19
    let maxExpiryNumber = 4
    let maxCVV = 4
    
    var objCardDetail = CardObject.init([:])
    
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
            self.viewDebitCard.createButtonShadow()
            self.viewCreditCard.createButtonShadow()
            
            self.btnAddCard.layer.cornerRadius = self.btnAddCard.frame.height / 2.0
            self.btnAddCard.createButtonShadow()
        }
        
        self.txtDebitCardNo.setLeftPadding()
        self.txtDebitExpiryDate.setLeftPadding()
        self.txtDebitCVV.setLeftPadding()
        self.txtCreditCardNo.setLeftPadding()
        self.txtCreditExpiryDate.setLeftPadding()
        self.txtCreditCVV.setLeftPadding()
                
        if self.isFromEdit == false {
            self.viewLineDebit.isHidden = false
            self.viewLineCredit.isHidden = false
            
            self.viewDebitCard.isHidden = true
            self.viewCreditCard.isHidden = true
                    
            self.btnAddCard.isHidden = true
            self.btnAddCard.setTitle("ADD", for: [])
        } else {
            if self.objCardDetail.card_type == "debit" {
                self.imgRadioDebit.image = UIImage.init(named: "radio_check")
                self.imgRadioCredit.image = UIImage.init(named: "radio_uncheck")
                
                self.viewLineDebit.isHidden = true
                self.viewLineCredit.isHidden = false
                
                self.viewDebitCard.isHidden = false
                self.viewCreditCard.isHidden = true
                        
                self.strPaymentType = "DebitCard"
                                
                self.txtDebitCardNo.text = self.objCardDetail.card_no
                self.txtDebitExpiryDate.text = self.objCardDetail.card_expiry
            } else {
                self.imgRadioDebit.image = UIImage.init(named: "radio_uncheck")
                self.imgRadioCredit.image = UIImage.init(named: "radio_check")
                
                self.viewLineDebit.isHidden = false
                self.viewLineCredit.isHidden = true
                
                self.viewDebitCard.isHidden = true
                self.viewCreditCard.isHidden = false
                        
                self.strPaymentType = "CreditCard"
                
                self.txtCreditCardNo.text = self.objCardDetail.card_no
                self.txtCreditExpiryDate.text = self.objCardDetail.card_expiry
            }
            
            self.btnAddCard.isHidden = false
            self.btnAddCard.setTitle("UPDATE", for: [])
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnClosePopupClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRadioDebitClick(_ sender: UIButton) {
        self.imgRadioDebit.image = UIImage.init(named: "radio_check")
        self.imgRadioCredit.image = UIImage.init(named: "radio_uncheck")
        
        self.viewLineDebit.isHidden = true
        self.viewLineCredit.isHidden = false
        
        self.viewDebitCard.isHidden = false
        self.viewCreditCard.isHidden = true
                
        self.strPaymentType = "DebitCard"
        self.btnAddCard.isHidden = false
    }
    
    @IBAction func btnRadioCreditClick(_ sender: UIButton) {
        self.imgRadioDebit.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCredit.image = UIImage.init(named: "radio_check")
        
        self.viewLineDebit.isHidden = false
        self.viewLineCredit.isHidden = true
        
        self.viewDebitCard.isHidden = true
        self.viewCreditCard.isHidden = false
                
        self.strPaymentType = "CreditCard"
        self.btnAddCard.isHidden = false
    }
    
    @IBAction func btnAddCardClick(_ sender: UIButton) {
        if self.strPaymentType == "DebitCard" {
            if self.txtDebitCardNo.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Card number is required")
            }
            else if self.txtDebitExpiryDate.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Expiry date is required")
            }
            else if self.txtDebitCVV.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "CVV is required")
            }
            else {
                if self.isFromEdit == false {
                    self.btnAddCard.isUserInteractionEnabled = false
                    self.callAddNewCardAPI()
                } else {
                    self.btnAddCard.isUserInteractionEnabled = false
                    self.callEditCardAPI()
                }
            }
        } else if self.strPaymentType == "CreditCard" {
            if self.txtCreditCardNo.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Card number is required")
            }
            else if self.txtCreditExpiryDate.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Expiry date is required")
            }
            else if self.txtCreditCVV.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "CVV is required")
            }
            else {
                if self.isFromEdit == false {
                    self.btnAddCard.isUserInteractionEnabled = false
                    self.callAddNewCardAPI()
                } else {
                    self.btnAddCard.isUserInteractionEnabled = false
                    self.callEditCardAPI()
                }
            }
        }
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension AddCardPopupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //no dots allowed
        if string == "." {
            return false
        }

        guard string.compactMap({ Int(String($0)) }).count ==
                string.count else { return false }
        
        let text = textField.text ?? ""
        
        if textField == self.txtDebitCardNo || textField == self.txtCreditCardNo {
            let newText: NSString = textField.text! as NSString
            let resultString = newText.replacingCharacters(in: range, with: string)
            if resultString.count > maxCardNumber {
                return false
            }
        }
        else if textField == self.txtDebitExpiryDate || textField == self.txtCreditExpiryDate {
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 2, withSeparator: "/")//.chunkFormatted()
            }
            else {
                let newText = String((text + string).filter({ $0 != "/" }).prefix(maxExpiryNumber))
                textField.text = newText.chunkFormatted(withChunkSize: 2, withSeparator: "/")//.chunkFormatted()
            }
            return false
        }
        else if textField == self.txtDebitCVV || textField == self.txtCreditCVV {
            let newText: NSString = textField.text! as NSString
            let resultString = newText.replacingCharacters(in: range, with: string)
            if resultString.count > maxCVV {
                return false
            }
        }
        return true
    }
}

//MARK: - API CALL -

extension AddCardPopupVC {
    //ADD NEW CARD
    func callAddNewCardAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        
        if self.strPaymentType == "DebitCard" {
            params["card_type"] = "debit"
            params["card_hodername"] = objUserDetail.userName
            params["card_no"] = self.txtDebitCardNo.text ?? ""
            params["card_expiry"] = self.txtDebitExpiryDate.text ?? ""
        } else {
            params["card_type"] = "credit"
            params["card_hodername"] = objUserDetail.userName
            params["card_no"] = self.txtCreditCardNo.text ?? ""
            params["card_expiry"] = self.txtCreditExpiryDate.text ?? ""
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.CARD, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        strongSelf.btnAddCard.isUserInteractionEnabled = true
                        
                        NotificationCenter.default.post(name: Notification.Name(kUpdateCardDetail), object: nil)
                        
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnAddCard.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnAddCard.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnAddCard.isUserInteractionEnabled = true
        }
    }
    
    //EDIT CARD
    func callEditCardAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        
        if self.strPaymentType == "DebitCard" {
            params["card_type"] = "debit"
            params["card_hodername"] = objUserDetail.userName
            params["card_no"] = self.txtDebitCardNo.text ?? ""
            params["card_expiry"] = self.txtDebitExpiryDate.text ?? ""
        } else {
            params["card_type"] = "credit"
            params["card_hodername"] = objUserDetail.userName
            params["card_no"] = self.txtCreditCardNo.text ?? ""
            params["card_expiry"] = self.txtCreditExpiryDate.text ?? ""
        }
        
        let strURL = Constants.URLS.CARD + "/" + "\(self.objCardDetail.id)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        strongSelf.btnAddCard.isUserInteractionEnabled = true
                        
                        NotificationCenter.default.post(name: Notification.Name(kUpdateCardDetail), object: nil)
                        
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnAddCard.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnAddCard.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnAddCard.isUserInteractionEnabled = true
        }
    }
}
