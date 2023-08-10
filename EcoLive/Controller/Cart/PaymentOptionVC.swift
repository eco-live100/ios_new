//
//  PaymentOptionVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 24/06/21.
//

import UIKit
import Stripe
import CoreLocation
import SwiftyJSON

class PaymentOptionVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgRadioDebit: UIImageView!
    @IBOutlet weak var imgRadioCredit: UIImageView!
    @IBOutlet weak var imgRadioWallet: UIImageView!
    @IBOutlet weak var viewLineDebit: UIView!
    @IBOutlet weak var viewLineCredit: UIView!
    @IBOutlet weak var viewLineWallet: UIView!
    
    @IBOutlet weak var viewDebitCard: UIView!
    @IBOutlet weak var txtDebitCardNo: NoPopUpTextField!
    @IBOutlet weak var txtDebitExpiryDate: NoPopUpTextField!
    @IBOutlet weak var txtDebitCVV: NoPopUpTextField!
    
    @IBOutlet weak var viewSaveDebitCard: UIView!
    @IBOutlet weak var btnSaveDebitCard: UIButton!
    
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var txtCreditCardNo: NoPopUpTextField!
    @IBOutlet weak var txtCreditExpiryDate: NoPopUpTextField!
    @IBOutlet weak var txtCreditCVV: NoPopUpTextField!
    
    @IBOutlet weak var viewSaveCreditCard: UIView!
    @IBOutlet weak var btnSaveCreditCard: UIButton!
    
    @IBOutlet weak var stackviewWallet: UIStackView!
    @IBOutlet weak var lblBalance: UILabel!
    
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var viewTransactionFailBG: UIView!
    @IBOutlet weak var viewTransactionFail: UIView!
    
    var objFirstAddress = AddressObject.init([:])
    var objWalletDetail = WalletObject.init([:])
    var objCardDetail = CardObject.init([:])
    
    var strShopID = ""
    var strProductId = ""
    var strProductColor = ""
    var strPurchaseType = ""
    
    var payAmount: Double = 0.0
    var strPaymentType = ""
    
    var strLattitude = ""
    var strLongitude = ""
    
    let maxCardNumber = 19
    let maxExpiryNumber = 4
    let maxCVV = 4
    
    var isBuyNow:Bool = false
    var isFoundAnySavedCard:Bool = false
    
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
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.viewDebitCard.createButtonShadow()
            self.viewCreditCard.createButtonShadow()
            
            self.btnPay.layer.cornerRadius = self.btnPay.frame.height / 2.0
            self.btnPay.createButtonShadow()
            
            self.viewTransactionFail.createButtonShadow()
        }
        
//        for view in self.view.subviews {
//            if let textField = view as? UITextField {
//                textField.setLeftPadding()
//            }
//        }
        
        self.txtDebitCardNo.setLeftPadding()
        self.txtDebitExpiryDate.setLeftPadding()
        self.txtDebitCVV.setLeftPadding()
        self.txtCreditCardNo.setLeftPadding()
        self.txtCreditExpiryDate.setLeftPadding()
        self.txtCreditCVV.setLeftPadding()
        
        self.viewLineDebit.isHidden = false
        self.viewLineCredit.isHidden = false
        self.viewLineWallet.isHidden = false
        
        self.viewDebitCard.isHidden = true
        self.viewSaveDebitCard.isHidden = true
        self.stackviewWallet.isHidden = true
        
        self.viewCreditCard.isHidden = true
        self.viewSaveCreditCard.isHidden = true
        
        self.btnPay.isHidden = true
        
        self.viewTransactionFailBG.isHidden = true
        
        let geocoder = CLGeocoder()
        let address = self.objFirstAddress.userAddresssLine1 + ", " + self.objFirstAddress.city + ", " + self.objFirstAddress.state + " " + self.objFirstAddress.userPincode
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                debugPrint("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                debugPrint("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                
                self.strLattitude = String(coordinates.latitude)
                self.strLongitude = String(coordinates.longitude)
            }
        })
        
        self.callGetCardDetail()
        self.callGetWalletBalance()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWalletBalance), name: NSNotification.Name(rawValue: kUpdateWalletBalance), object: nil)
    }
    
    //MARK: - HELPER -
    
    @objc func updateWalletBalance() {
        self.callGetWalletBalance()
    }
    
    func paymentMethod() {
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
                self.showAlertWithTextField()
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
                self.showAlertWithTextField()
            }
        } else {
            if self.objWalletDetail.wallet >= self.payAmount {
                self.btnPay.isUserInteractionEnabled = false
                if self.isBuyNow == true {
                    self.callBuynowOrderAPI(StripeToken: "")
                } else {
                    self.callCreateCartOrderAPI(StripeToken: "")
                }
            } else {
                GlobalData.shared.displayConfirmationAlert(self, title: "Insufficient Balance", message: "Would you like to add money in your wallet?", btnTitle1: "Cancel", btnTitle2: "Proceed", actionBlock: { (isConfirmed) in
                    if isConfirmed {
                        let controller = GlobalData.addMoneyStoryBoard().instantiateViewController(withIdentifier: "AddMoneyVC") as! AddMoneyVC
                        controller.isFromCartPayment = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                })
            }
        }
    }
    
    func showAlertWithTextField() {
        let alert = UIAlertController(title: "Password", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let saveAction = UIAlertAction(title:"Proceed", style: .default, handler: { (action) -> Void in
            if let txtField = alert.textFields?.first, let text = txtField.text {
                // operations
                debugPrint("Text==>" + text)
                self.callCheckSecurityAPI(Password: text)
            }
        })
        alert.addAction(saveAction)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Password"
            textField.isSecureTextEntry = true
            saveAction.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                saveAction.isEnabled = textField.text!.count > 0
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func createStripeToken() {
        if self.strPaymentType == "DebitCard" {
            //card parameters
            let stripeCardParams = STPCardParams()
            stripeCardParams.number = self.txtDebitCardNo.text
            let expiryParameters = self.txtDebitExpiryDate.text?.components(separatedBy: "/")
            stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
            stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
            stripeCardParams.cvc = self.txtDebitCVV.text
            
            // Aquire stripe token
            STPAPIClient.init(publishableKey: stripePublishableKey).createToken(withCard: stripeCardParams) { (token, error) in
                if let error = error {
                    print (error)
                } else if let token = token {
                    print (token)
                    print (token.tokenId)
                    
                    self.btnPay.isUserInteractionEnabled = false
                    if self.isBuyNow == true {
                        self.callBuynowOrderAPI(StripeToken: token.tokenId)
                    } else {
                        self.callCreateCartOrderAPI(StripeToken: token.tokenId)
                    }
                }
            }
        } else if self.strPaymentType == "CreditCard" {
            let stripeCardParams = STPCardParams()
            stripeCardParams.number = self.txtCreditCardNo.text
            let expiryParameters = self.txtCreditExpiryDate.text?.components(separatedBy: "/")
            stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
            stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
            stripeCardParams.cvc = self.txtCreditCVV.text
            
            STPAPIClient.init(publishableKey: stripePublishableKey).createToken(withCard: stripeCardParams) { (token, error) in
                if let error = error {
                    print (error)
                } else if let token = token {
                    print (token)
                    print (token.tokenId)
                    
                    self.btnPay.isUserInteractionEnabled = false
                    if self.isBuyNow == true {
                        self.callBuynowOrderAPI(StripeToken: token.tokenId)
                    } else {
                        self.callCreateCartOrderAPI(StripeToken: token.tokenId)
                    }
                }
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRadioDebitClick(_ sender: UIButton) {
        self.imgRadioDebit.image = UIImage.init(named: "radio_check")
        self.imgRadioCredit.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioWallet.image = UIImage.init(named: "radio_uncheck")
        
        self.viewLineDebit.isHidden = true
        self.viewLineCredit.isHidden = false
        self.viewLineWallet.isHidden = false
        
        self.viewDebitCard.isHidden = false
        self.viewSaveDebitCard.isHidden = false
        
        self.viewCreditCard.isHidden = true
        self.viewSaveCreditCard.isHidden = true
        
        self.stackviewWallet.isHidden = true
        
        self.strPaymentType = "DebitCard"
        self.btnPay.isHidden = false
    }
    
    @IBAction func btnRadioCreditClick(_ sender: UIButton) {
        self.imgRadioDebit.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCredit.image = UIImage.init(named: "radio_check")
        self.imgRadioWallet.image = UIImage.init(named: "radio_uncheck")
        
        self.viewLineDebit.isHidden = false
        self.viewLineCredit.isHidden = true
        self.viewLineWallet.isHidden = false
        
        self.viewDebitCard.isHidden = true
        self.viewSaveDebitCard.isHidden = true
        
        self.viewCreditCard.isHidden = false
        self.viewSaveCreditCard.isHidden = false
        
        self.stackviewWallet.isHidden = true
        
        self.strPaymentType = "CreditCard"
        self.btnPay.isHidden = false
    }
    
    @IBAction func btnRadioWalletClick(_ sender: UIButton) {
        self.imgRadioDebit.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioCredit.image = UIImage.init(named: "radio_uncheck")
        self.imgRadioWallet.image = UIImage.init(named: "radio_check")
        
        self.viewLineDebit.isHidden = false
        self.viewLineCredit.isHidden = false
        self.viewLineWallet.isHidden = true
        
        self.viewDebitCard.isHidden = true
        self.viewSaveDebitCard.isHidden = true
        
        self.viewCreditCard.isHidden = true
        self.viewSaveCreditCard.isHidden = true
        
        self.stackviewWallet.isHidden = false
        
        self.strPaymentType = "Wallet"
        self.btnPay.isHidden = false
    }
    
    @IBAction func btnSaveDebitCardClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnSaveCreditCardClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnPayClick(_ sender: UIButton) {
//        self.viewTransactionFailBG.isHidden = false
        self.paymentMethod()
    }
    
    @IBAction func btnRetryPopupClick(_ sender: UIButton) {
        self.viewTransactionFailBG.isHidden = true
    }
    
    @IBAction func btnOkPopupClick(_ sender: UIButton) {
        self.viewTransactionFailBG.isHidden = true
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension PaymentOptionVC: UITextFieldDelegate {
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

extension PaymentOptionVC {
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
                            
                            strongSelf.isFoundAnySavedCard = true
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        strongSelf.isFoundAnySavedCard = false
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
                                                                                    
                            let attString = GlobalData.shared.convertStringtoAttributedText(strFirst: "Available Balance:" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: strongSelf.lblBalance.font.pointSize)!, strFirstColor: UIColor.init(hex: 0x333333), strSecond: "$\(strongSelf.objWalletDetail.wallet)", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_BOLD, size: strongSelf.lblBalance.font.pointSize + 1)!, strSecondColor: UIColor.init(hex: 0x333333))
                            
                            strongSelf.lblBalance.attributedText = attString
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
    
    //CHECK SECURITY API
    func callCheckSecurityAPI(Password password: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["password"] = password
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.CHECK_SECURITY, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        strongSelf.createStripeToken()
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.showAlertWithTextField()
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //BUY NOW ORDER API
    func callBuynowOrderAPI(StripeToken stripeToken: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strPaymentType = ""
        if self.strPaymentType == "DebitCard" || self.strPaymentType == "CreditCard" {
            strPaymentType = "Bank"
        } else if self.strPaymentType == "Wallet" {
            strPaymentType = "Wallat"
        }
        
        var params: [String:Any] = [:]
        params["shop_id"] = self.strShopID
        params["product_id"] = self.strProductId
        params["userType"] = "registerd"
        params["address"] = self.objFirstAddress.userAddresssLine1
        params["latitude"] = self.strLattitude
        params["longitude"] = self.strLongitude
        params["zipCode"] = self.objFirstAddress.userPincode
        params["contactNo"] = self.objFirstAddress.userContact
//        params["description"] = ""
        params["paymentType"] = strPaymentType
        params["paymentStatus"] = "Pending"
        params["orderStatus"] = "Placed"
//        params["product_price"] = "\(self.payAmount)"
        params["stripe_token"] = stripeToken
        params["shipping_adr_id"] = self.objFirstAddress._id
        params["product_color"] = self.strProductColor
        params["purchase_type"] = self.strPurchaseType
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestPOSTURL(Constants.URLS.BUYNOW, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        strongSelf.btnPay.isUserInteractionEnabled = true
                        
                        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                        controller.isFromCart = true
                        controller.objCardDetail = strongSelf.objCardDetail
                        controller.strPaymentType = strongSelf.strPaymentType
                        controller.strDebitCardNo = strongSelf.txtDebitCardNo.text ?? ""
                        controller.strDebitExpiry = strongSelf.txtDebitExpiryDate.text ?? ""
                        controller.strCreditCardNo = strongSelf.txtCreditCardNo.text ?? ""
                        controller.strCreditExpiry = strongSelf.txtCreditExpiryDate.text ?? ""
                        controller.isFoundAnySavedCard = strongSelf.isFoundAnySavedCard
                        controller.isSelectDebitCard = strongSelf.btnSaveDebitCard.isSelected
                        controller.isSelectCreditCard = strongSelf.btnSaveCreditCard.isSelected
                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                        
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnPay.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnPay.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnPay.isUserInteractionEnabled = true
        }
    }
    
    //CREATE CART ORDER API
    func callCreateCartOrderAPI(StripeToken stripeToken: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

        var strPaymentType = ""
        if self.strPaymentType == "DebitCard" || self.strPaymentType == "CreditCard" {
            strPaymentType = "Bank"
        } else if self.strPaymentType == "Wallet" {
            strPaymentType = "Wallat"
        }
        
        var params: [String:Any] = [:]
        params["shop_id"] = self.strShopID
//        params["product_id"] = ""
        params["userType"] = "registerd"
        params["address"] = self.objFirstAddress.userAddresssLine1
        params["latitude"] = self.strLattitude
        params["longitude"] = self.strLongitude
        params["zipCode"] = self.objFirstAddress.userPincode
        params["contactNo"] = self.objFirstAddress.userContact
//        params["description"] = ""
        params["paymentType"] = strPaymentType
        params["paymentStatus"] = "Pending"
        params["orderStatus"] = "Placed"
//        params["product_price"] = "\(self.payAmount)"
        params["stripe_token"] = stripeToken
        params["shipping_adr_id"] = self.objFirstAddress._id

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        AFWrapper.shared.requestPOSTURL(Constants.URLS.ORDER, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }

            GlobalData.shared.hideProgress()

            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        strongSelf.btnPay.isUserInteractionEnabled = true
                        
                        let controller = GlobalData.sendMoneyStoryBoard().instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                        controller.isFromCart = true
                        controller.objCardDetail = strongSelf.objCardDetail
                        controller.strPaymentType = strongSelf.strPaymentType
                        controller.strDebitCardNo = strongSelf.txtDebitCardNo.text ?? ""
                        controller.strDebitExpiry = strongSelf.txtDebitExpiryDate.text ?? ""
                        controller.strCreditCardNo = strongSelf.txtCreditCardNo.text ?? ""
                        controller.strCreditExpiry = strongSelf.txtCreditExpiryDate.text ?? ""
                        controller.isFoundAnySavedCard = strongSelf.isFoundAnySavedCard
                        controller.isSelectDebitCard = strongSelf.btnSaveDebitCard.isSelected
                        controller.isSelectCreditCard = strongSelf.btnSaveCreditCard.isSelected
                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnPay.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnPay.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnPay.isUserInteractionEnabled = true
        }
    }
}
