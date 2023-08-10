//
//  PaymentSuccessVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/06/21.
//

import UIKit
import SwiftyJSON

class PaymentSuccessVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var imgThanksBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    
    var isFromCart:Bool = false
    
    var objCardDetail = CardObject.init([:])
    var strPaymentType = ""
    var strDebitCardNo = ""
    var strDebitExpiry = ""
    var strCreditCardNo = ""
    var strCreditExpiry = ""
    var isFoundAnySavedCard:Bool = false
    var isSelectDebitCard:Bool = false
    var isSelectCreditCard:Bool = false
    
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
        if Constants.DeviceType.IS_IPHONE_5 {
            self.imgThanksBottomConstraint.constant = -50
        } else if Constants.DeviceType.IS_IPHONE_6 {
            self.imgThanksBottomConstraint.constant = -30
        } else if Constants.DeviceType.IS_IPHONE_6P || Constants.DeviceType.IS_IPHONE_X {
            self.imgThanksBottomConstraint.constant = -20
        } else if Constants.DeviceType.IS_IPHONE_11_PRO_MAX || Constants.DeviceType.IS_IPHONE_12_PRO {
            self.imgThanksBottomConstraint.constant = -10
        } else if Constants.DeviceType.IS_IPHONE_12_PRO_MAX {
            self.imgThanksBottomConstraint.constant = -5
        }
        
        DispatchQueue.main.async {
            self.btnHome.layer.cornerRadius = self.btnHome.frame.height / 2.0
            self.btnHome.createButtonShadow()
        }
        
        if self.isFromCart == true {
            self.lblMessage.text = "You're order successfully done"
            
            if self.strPaymentType == "DebitCard" || self.strPaymentType == "CreditCard" {
                if self.isFoundAnySavedCard == false {
                    if (self.strPaymentType == "DebitCard" && self.isSelectDebitCard == true) || (self.strPaymentType == "CreditCard" && self.isSelectCreditCard == true) {
                        self.btnHome.isUserInteractionEnabled = false
                        self.callAddNewCardAPI()
                    }
                } else {
                    if (self.strPaymentType == "DebitCard" && self.isSelectDebitCard == true) || (self.strPaymentType == "CreditCard" && self.isSelectCreditCard == true) {
                        self.btnHome.isUserInteractionEnabled = false
                        self.callEditCardAPI()
                    }
                }
            }
        } else {
            self.lblMessage.text = "You're successfully transferred money"
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnHomeClick(_ sender: UIButton) {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
}

//MARK: - API CALL -

extension PaymentSuccessVC {
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
            params["card_no"] = self.strDebitCardNo
            params["card_expiry"] = self.strDebitExpiry
        } else {
            params["card_type"] = "credit"
            params["card_hodername"] = objUserDetail.userName
            params["card_no"] = self.strCreditCardNo
            params["card_expiry"] = self.strCreditExpiry
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.CARD, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        strongSelf.btnHome.isUserInteractionEnabled = true
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnHome.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        strongSelf.btnHome.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnHome.isUserInteractionEnabled = true
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
            params["card_no"] = self.strDebitCardNo
            params["card_expiry"] = self.strDebitExpiry
        } else {
            params["card_type"] = "credit"
            params["card_hodername"] = objUserDetail.userName
            params["card_no"] = self.strCreditCardNo
            params["card_expiry"] = self.strCreditExpiry
        }
        
        let strURL = Constants.URLS.CARD + "/" + "\(self.objCardDetail.id)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        strongSelf.btnHome.isUserInteractionEnabled = true
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnHome.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        strongSelf.btnHome.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnHome.isUserInteractionEnabled = true
        }
    }
}
