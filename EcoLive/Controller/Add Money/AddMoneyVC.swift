//
//  AddMoneyVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 22/06/21.
//

import UIKit
import SwiftValidators
import DLRadioButton
import SwiftyJSON
import Stripe

class AddMoneyVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblPayBalance: UILabel!
    @IBOutlet weak var lblAddUpto: UILabel!
    @IBOutlet weak var lblMaximumLimit: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var viewSelectSavedCard: UIView!
    @IBOutlet weak var viewLineSavedCard: UIView!
    @IBOutlet weak var viewSavedCard: UIView!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCardExpiry: UILabel!
    @IBOutlet weak var txtCVV: NoPopUpTextField!
    
    @IBOutlet weak var stackviewOtherCard: UIStackView!
    @IBOutlet weak var viewLineOtherCard: UIView!
    @IBOutlet weak var viewOtherCard: UIView!
    @IBOutlet weak var txtOtherCardNo: NoPopUpTextField!
    @IBOutlet weak var txtOtherExpiryDate: NoPopUpTextField!
    @IBOutlet weak var txtOtherCVV: NoPopUpTextField!
    
    @IBOutlet weak var viewAddCard: UIView!
    @IBOutlet var btnCardType: DLRadioButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isFromCartPayment:Bool = false
    
    var cardType:Int = -1
    
    let maxCardNumber = 19
    let maxExpiryNumber = 4
    let maxCVV = 4
    
    var objWalletDetail = WalletObject.init([:])
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
        self.viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        
        self.btnCardType.isMultipleSelectionEnabled = false
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.viewSavedCard.createButtonShadow()
            self.viewOtherCard.createButtonShadow()
            self.viewAddCard.createButtonShadow()
            
            self.btnContinue.layer.cornerRadius = self.btnContinue.frame.height / 2.0
            self.btnContinue.createButtonShadow()
        }
        
        self.txtOtherCardNo.setLeftPadding()
        self.txtOtherExpiryDate.setLeftPadding()
        self.txtOtherCVV.setLeftPadding()
        
        self.viewLineSavedCard.isHidden = false
        self.viewLineOtherCard.isHidden = false
        
        let strMonthly = "10000.00"
        let strYearly = "100000.00"
        
        self.lblAddUpto.text = "You can add up to" + " " + "$ \(strMonthly)"
        self.lblMaximumLimit.text = "Maximum limit to add money is $ \(strMonthly) per month and $ \(strYearly) per year."
        
        self.viewSelectSavedCard.isHidden = true
        self.viewSavedCard.isHidden = true
        self.stackviewOtherCard.isHidden = true
        self.viewOtherCard.isHidden = true
//        self.viewAddCard.isHidden = true
        
        self.viewAddCard.isHidden = false

        
        self.callGetCardDetail()
        self.callGetWalletBalance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCardDetail), name: NSNotification.Name(rawValue: kUpdateCardDetail), object: nil)
    }
    
    //MARK: - HELPER -
    
    @objc func updateCardDetail() {
        self.callGetCardDetail()
    }
    
    func setupCardData() {
        var myString = self.objCardDetail.card_no
        let stringlength = myString.count
        let e = try? NSRegularExpression(pattern: "\\d", options: [])
        var finalString = ""
        
        if stringlength == 14 {
            myString = (e?.stringByReplacingMatches(in: myString, options: [], range: NSRange(location: 0, length: stringlength-4), withTemplate: "X"))!

            finalString = myString.codeFormat()
        }
        else if stringlength == 15 {
            myString = (e?.stringByReplacingMatches(in: myString, options: [], range: NSRange(location: 0, length: stringlength-5), withTemplate: "X"))!
            
            finalString = myString.codeFormat()
        }
        else { //if stringlength == 16
            myString = (e?.stringByReplacingMatches(in: myString, options: [], range: NSRange(location: 0, length: stringlength-4), withTemplate: "X"))!
            myString = myString.separate(every: 4, with: " ") // Seprate with space every 4 character
            
            finalString = myString
        }
        
        self.lblCardName.text = self.objCardDetail.card_hodername
        self.lblCardNumber.text = finalString
        self.lblCardExpiry.text = "Valid Till \(self.objCardDetail.card_expiry)"
    }
    
    func createStripeToken(CardNumber cardNumber: String, CardExpiry cardExpiry:String, CardCVV cardCVV:String) {
        let stripeCardParams = STPCardParams()
        stripeCardParams.number = cardNumber
        let expiryParameters = cardExpiry.components(separatedBy: "/")
        stripeCardParams.expMonth = UInt(expiryParameters.first ?? "0") ?? 0
        stripeCardParams.expYear = UInt(expiryParameters.last ?? "0") ?? 0
        stripeCardParams.cvc = cardCVV
        
        STPAPIClient.init(publishableKey: stripePublishableKey).createToken(withCard: stripeCardParams) { (token, error) in
            if let error = error {
                print (error)
            } else if let token = token {
                print (token)
                print (token.tokenId)
                
                self.btnContinue.isUserInteractionEnabled = false
                self.addMoneyUsingToken(stripeToken: token)
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCardTypeClick(radioButton : DLRadioButton) {
        if radioButton.accessibilityIdentifier ?? "" == "Savedcard" {
            self.cardType = 0
            
            self.viewLineSavedCard.isHidden = true
            self.viewLineOtherCard.isHidden = false
            
            self.viewSavedCard.isHidden = false
            self.viewOtherCard.isHidden = true
        } else if radioButton.accessibilityIdentifier ?? "" ==  "Othercard" {
            self.cardType = 1
            
            self.viewLineSavedCard.isHidden = false
            self.viewLineOtherCard.isHidden = true
            
            self.viewSavedCard.isHidden = true
            self.viewOtherCard.isHidden = false
        }
        debugPrint("SELECTED OPTION:- \(self.cardType)")
    }
    
    @IBAction func btnAddCardClick(_ sender: UIButton) {
        let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddCardPopupVC") as! AddCardPopupVC
        controller.isFromEdit = false
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnEditCardClick(_ sender: UIButton) {
        let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddCardPopupVC") as! AddCardPopupVC
        controller.isFromEdit = true
        controller.objCardDetail = self.objCardDetail
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnContinueClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let totalAmount = ("\(self.txtAmount.text ?? "")" as NSString).doubleValue
        
        if self.txtAmount.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Amount is required")
        }
        else if totalAmount > 10000 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Maximum amount limit is 10000")
        }
        else if self.cardType == -1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Select card or add new card first")
        }
        else if self.cardType == 0 { //SAVED CARD
            if self.txtCVV.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "CVV is required")
            } else {
                self.createStripeToken(CardNumber: self.objCardDetail.card_no, CardExpiry: self.objCardDetail.card_expiry, CardCVV: self.txtCVV.text ?? "")
            }
        }
        else if self.cardType == 1 { //OTHER CARD
            if self.txtOtherCardNo.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Card number is required")
            }
            else if self.txtOtherExpiryDate.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Expiry date is required")
            }
            else if self.txtOtherCVV.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "CVV is required")
            }
            else {
                self.createStripeToken(CardNumber: self.txtOtherCardNo.text ?? "", CardExpiry: self.txtOtherExpiryDate.text ?? "", CardCVV: self.txtOtherCVV.text ?? "")
            }
        }
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension AddMoneyVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtAmount {
            if string == "" {
                return true
            }
            
            let text: NSString = textField.text! as NSString
            let resultString = text.replacingCharacters(in: range, with: string)
            
            if textField == self.txtAmount {
                let textArray = resultString.components(separatedBy: ".")
                
                if textArray.count == 1 {
                    let firstString = textArray.first
                    if firstString!.count > 5 { // Check first number
                        return false
                    }
                }
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
        } else {
            //no dots allowed
            if string == "." {
                return false
            }

            guard string.compactMap({ Int(String($0)) }).count ==
                    string.count else { return false }
            
            let text = textField.text ?? ""
            
            if textField == self.txtOtherCardNo {
                let newText: NSString = textField.text! as NSString
                let resultString = newText.replacingCharacters(in: range, with: string)
                if resultString.count > maxCardNumber {
                    return false
                }
            }
            else if textField == self.txtOtherExpiryDate {
                if string.count == 0 {
                    textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 2, withSeparator: "/")//.chunkFormatted()
                }
                else {
                    let newText = String((text + string).filter({ $0 != "/" }).prefix(maxExpiryNumber))
                    textField.text = newText.chunkFormatted(withChunkSize: 2, withSeparator: "/")//.chunkFormatted()
                }
                return false
            }
            else if textField == self.txtOtherCVV {
                let newText: NSString = textField.text! as NSString
                let resultString = newText.replacingCharacters(in: range, with: string)
                if resultString.count > maxCVV {
                    return false
                }
            }
        }
        return true
    }
}

//MARK: - API CALL -

extension AddMoneyVC {
    //GET CARD DETAIL
    func callGetCardDetail() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
                
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(Constants.URLS.CARD) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            
                            strongSelf.objCardDetail = CardObject.init(payload)
                            
                            strongSelf.viewSelectSavedCard.isHidden = false
                            strongSelf.stackviewOtherCard.isHidden = false
                            strongSelf.viewAddCard.isHidden = true
                            
                            strongSelf.setupCardData()
                            
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        strongSelf.viewSelectSavedCard.isHidden = true
                        strongSelf.stackviewOtherCard.isHidden = true
                        strongSelf.viewAddCard.isHidden = false
                    }
                }
            }
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
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
                            
                            strongSelf.lblPayBalance.text = "Eco live pay balance" + " " + "$\(strongSelf.objWalletDetail.wallet)"
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
    
    //ADD MONEY TO WALLET
    func addMoneyUsingToken(stripeToken: STPToken) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["amount"] = self.txtAmount.text ?? ""
        params["stripe_token"] = stripeToken.tokenId
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestPOSTURL(Constants.URLS.ADD_MONEY_WALLET, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnContinue.isUserInteractionEnabled = true
                        
                        strongSelf.txtAmount.text = ""
                        strongSelf.txtCVV.text = ""
                        strongSelf.txtOtherCardNo.text = ""
                        strongSelf.txtOtherExpiryDate.text = ""
                        strongSelf.txtOtherCVV.text = ""
                        
                        if strongSelf.isFromCartPayment == false {
                            strongSelf.callGetWalletBalance()
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(kUpdateWalletBalance), object: nil)
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnContinue.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnContinue.isUserInteractionEnabled = true
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
