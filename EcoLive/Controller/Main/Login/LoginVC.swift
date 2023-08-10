//
//  LoginVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 04/06/21.
//

import UIKit
import SwiftyJSON
import CometChatPro
import SwiftValidators
import CountryPickerView

class LoginVC: UIViewController {
    
    static func getObject()-> LoginVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        if let vc = vc {
            return vc
        }
        return LoginVC()
    }
    
    //MARK: - PROPERTIES & OUTLETS
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgRemember: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var countryPicker: CountryPickerView!

    var loginType = 0
    var strCountryCode = ""
    
    //MARK: -  Property Observer
    
    var strMobileNumber : String = ""{
        didSet{
            txtPhone.text = strMobileNumber
        }
    }
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
// :- Note For Twitter
//    var swifter: Swifter!
//    var accToken: Credential.OAuthAccessToken?
    
    var socialSigninInfo = SocialSigninInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - SETUP VIEW
    
    func setupViewDetail() {
        
        let attString = GlobalData.shared.convertStringtoAttributedText(strFirst: "Don't have an account?" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: (self.btnSignup.titleLabel?.font.pointSize)!)!, strFirstColor: UIColor.init(rgb: 0x333333), strSecond: "Sign up", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: (self.btnSignup.titleLabel?.font.pointSize)!)!, strSecondColor: UIColor.init(rgb: 0x3663F5))
        
        self.btnSignup.setAttributedTitle(attString, for: .normal)
        self.countryPicker.delegate = self
        self.countryPicker.showCountryCodeInView = false
        self.countryPicker.showPhoneCodeInView = true
        self.countryPicker.showCountryNameInView = false
        self.countryPicker.font = UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 16.0)!
        self.countryPicker.textColor = UIColor.init(hex: 0x333333)
        self.countryPicker.flagSpacingInView = 0.0
        let country = self.countryPicker.selectedCountry
        self.strCountryCode = country.phoneCode
        
        DispatchQueue.main.async {
            
            self.viewPhone.layer.cornerRadius = self.viewPhone.frame.height / 2.0
            self.viewPhone.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPhone.layer.borderWidth = 1.0
            
            self.viewEmail.layer.cornerRadius = self.viewEmail.frame.height / 2.0
            self.viewEmail.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewEmail.layer.borderWidth = 1.0
            
            self.viewPassword.layer.cornerRadius = self.viewPassword.frame.height / 2.0
            self.viewPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPassword.layer.borderWidth = 1.0
            
            self.btnLogin.layer.cornerRadius = self.btnLogin.frame.height / 2.0
            self.btnLogin.createButtonShadow()
            
        }
        
        self.imgRemember.image = UIImage.init(named: "ic_uncheck")
        
        if let isRemember = defaults.object(forKey: kRememberMe) as? Bool {
            if isRemember == true {
                self.txtEmail.text = defaults.string(forKey: kRememberEmail)
                self.txtPassword.text = defaults.string(forKey: kRememberPassword)
                self.imgRemember.image = UIImage.init(named: "ic_check")
            }
        }
        
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnRememberMeClick(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.imgRemember.image == UIImage.init(named: "ic_uncheck") {
            self.imgRemember.image = UIImage.init(named: "ic_check")
        } else {
            self.imgRemember.image = UIImage.init(named: "ic_uncheck")
        }
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnSkipClick(_ sender: UIButton) {
        
//        let controller = GlobalData.pharmacyStoryBoard().instantiateViewController(withIdentifier: "PharmacyVC") as! PharmacyVC
//        self.navigationController?.pushViewController(controller, animated: true)
        
        pushHomeController()
    }

    //    @IBAction func btnFacebookClick(_ sender: UIButton) {
    //        self.view.endEditing(true)
    ////        self.loginWithFacebook()
    //    }
    //
    //    @IBAction func btnGoogleClick(_ sender: UIButton) {
    //        self.view.endEditing(true)
    ////        self.loginWithGoogle()
    //    }
    //
    //    @IBAction func btnInstagramClick(_ sender: UIButton) {
    //        self.view.endEditing(true)
    ////        self.loginWithInstagram()
    //    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        self.view.endEditing(true)
        

        if ((self.txtEmail.text ?? "").isNumber) {

            let phonetrimmedString = self.txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            //        else
            if self.txtEmail.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is required")
                
            }
            else if !self.txtEmail.isValidPhone() {
                GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is invalid")
            }
            else if !Validator.minLength(10).apply(phonetrimmedString) {
                GlobalData.shared.showDarkStyleToastMesage(message: "Phone number should be 10 character long")
            }


//            if self.txtEmail.isEmpty() == 1 {
//                GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
//            }
//            else if !self.txtEmail.isValidEmail() {
//                GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
//            }
            else if self.txtPassword.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Password is required")
            }
            else {
//                self.btnLogin.isUserInteractionEnabled = false
//                let email = self.txtEmail.text?.lowercased()
//                self.callLoginAPI(loginType: loginType, email: email ?? "", password: self.txtPassword.text!, name: String(), userId: String())

                self.btnLogin.isUserInteractionEnabled = false
                let email = self.txtEmail.text?.lowercased()
                self.callLoginAPI(loginType: loginType, email: email ?? "", password: self.txtPassword.text!, name: String(), userId: String())
            }

        }else{

            if self.txtEmail.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
            }
            else if !self.txtEmail.isValidEmail() {
                GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
            }
            else if self.txtPassword.isEmpty() == 1 {
                GlobalData.shared.showDarkStyleToastMesage(message: "Password is required")
            }
            else {
                self.btnLogin.isUserInteractionEnabled = false
                let email = self.txtEmail.text?.lowercased()
                self.callLoginAPI(loginType: loginType, email: email ?? "", password: self.txtPassword.text!, name: String(), userId: String())
            }

        }
        

    }
    
    @IBAction func onChangeTxtMobileNum(_ sender: UITextField) {
        strMobileNumber = sender.text ?? ""

        
    }
    
    @available(iOS 13.0, *)
    @IBAction func btnSocialLoginTap(_ sender: UIButton) {
        self.view.endEditing(true)
        switch sender.tag {
        case 1:
            openApplePaySheet()
        case 2:
            openFacebookSheet()
        case 3:
            openGoogleSignSheet()
        case 4:
            openTwitterSignSheet()
        default:
            print("default")
        }
    }
    
    @IBAction func btnSignupClick(_ sender: UIButton) {
        self.view.endEditing(true)
//        let controller = AddProductEcom.getObject()
//        self.navigationController?.pushViewController(controller, animated: true)
        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "UserSignupVC") as! UserSignupVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnSelectCountryClick(_ sender: UIButton) {
        self.countryPicker.showCountriesList(from: self)
    }
    
}

//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension LoginVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        } else if string == " " {
            if textField == self.txtEmail {
                return false
            }
        }
        return true
    }
}

//MARK: - API CALL -

extension LoginVC {
    
    func callLoginAPI(loginType: Int, email: String, password: String, name: String, userId: String) {
        
//        if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//
//        return
        
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var deviceToken: String = "123456"
        if defaults.value(forKey: "deviceToken") != nil {
            deviceToken = defaults.value(forKey: "deviceToken") as! String
        }
        
        var params: [String:Any] = [:]
        if loginType == 0 { //NORMAL
            params["emailMobile"] = email
            params["password"] = password
            params["loginType"] = "normal"
//            params["countryCode"] = self.strCountryCode
//            params["mobileNumber"] = self.txtPhone.text ?? ""
//            params["userType"] = "shop"
        }
        //        else if loginType == 1 {
        //            params["email"] = self.txtEmail.text
        //            params["password"] = self.txtPassword.text
        //            params["userType"] = "rider"
        //        } else if loginType == 2 {
        //            params["email"] = self.txtEmail.text
        //            params["password"] = self.txtPassword.text
        //            params["userType"] = "shop"
        //        }
        //        else if loginType == 1 { //FACEBOOK
        //            params["email"] = email
        //            params["loginType"] = "facebook"
        //            params["name"] = name
        //            params["facebook_id"] = userId
        //        }
        //        else if loginType == 2 { //GOOGLE
        //            params["email"] = email
        //            params["loginType"] = "google"
        //            params["name"] = name
        //            params["google_id"] = userId
        //        }
        //        else if loginType == 3 { //Instagram
        //            params["email"] = email
        //            params["loginType"] = "instagram"
        //            params["name"] = name
        //            params["instagram_id"] = userId
        //        }
        params["deviceType"] = kDeviceType
        params["deviceToken"] = deviceToken
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        DispatchQueue.main.async {
            NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.LOGIN, parameters: params) { responceget in
                print(responceget)
                
                let strongSelf = self
                GlobalData.shared.hideProgress()
                self.btnLogin.isUserInteractionEnabled = true
                
                switch responceget {
                case .success(let response):
                    
                    if let getData = response["data"] as? NSDictionary {
                        
                        let mobileVerified = getData.value(forKey: "mobileVerified") as? String
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        //                        if mobileVerified == true {
                        
                        let userDetail = response["data"] as! Dictionary<String, Any>
                        let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                        
                        let accessToken = userDetail["accessToken"] ?? ""

                        if let data = try? JSONEncoder().encode(object) {
                            
                            if strongSelf.imgRemember.image == UIImage.init(named: "ic_check") {
                                defaults.set(true, forKey: kRememberMe)
                                defaults.set(strongSelf.txtEmail.text ?? "", forKey: kRememberEmail)
                                defaults.set(strongSelf.txtPassword.text ?? "", forKey: kRememberPassword)
                            } else {
                                defaults.set(false, forKey: kRememberMe)
                            }
                            
                            defaults.set(data, forKey: kLoggedInUserData)
                            defaults.set(accessToken, forKey: kAuthToken)
                            defaults.synchronize()
                            
                            objUserDetail = object
                            
                            //                                DispatchQueue.main.async {
                            //                                    GlobalData.shared.hideProgress()
                            //                                    strongSelf.btnLogin.isUserInteractionEnabled = true
                            //                                    strongSelf.pushHomeController()
                            //                                }
                            //
                            
                            DispatchQueue.global().async {
                                
                                if mobileVerified == "1" {
                                    if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                        controller.phonenumber = "\(getData.object(forKey: "mobileNumber") as? String ?? "")"
                                        controller.countryCode = "\(getData.object(forKey: "countryCode") as? String ?? "")"
                                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }else{
                                    //defaults.set("123456", forKey: kAuthToken)
                                    strongSelf.pushHomeController()
                                }
                                
                                return
                                
                                CometChat.login(UID: objUserDetail._id, apiKey: Constants.CometChat.authKey, onSuccess: { (current_user) in
                                    
                                    DispatchQueue.main.async {
                                        GlobalData.shared.hideProgress()
                                        strongSelf.btnLogin.isUserInteractionEnabled = true
                                        
                                        if mobileVerified == "1" {
                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                                controller.phonenumber = "\(getData.object(forKey: "mobileNumber") as? String ?? "")"
                                                controller.countryCode = "\(getData.object(forKey: "countryCode") as? String ?? "")"
                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }else{
                                            //defaults.set("123456", forKey: kAuthToken)
                                            strongSelf.pushHomeController()
                                        }
                                            
//                                        }else{
//                                            strongSelf.pushHomeController
//                                        }
                                        
                                        //                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                        //                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
                                        //                                            }
                                        
                                    }
                                    
                                }) { (error) in
                                    
                                    DispatchQueue.main.async {
                                        
                                        strongSelf.btnLogin.isUserInteractionEnabled = true
                                        
                                        let userID = object._id
                                        let userName = object.userName
                                        
                                        //-: Sign up in CometChat
                                        let user = User(uid: userID, name: userName)
                                        
                                        CometChat.createUser(user: user, apiKey: Constants.CometChat.authKey, onSuccess: { (user) in
                                            DispatchQueue.main.async {
                                                GlobalData.shared.hideProgress()
                                                
                                                if mobileVerified == "1" {
                                                    if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                                        controller.phonenumber = "\(getData.object(forKey: "mobileNumber") as? String ?? "")"
                                                        controller.countryCode = "\(getData.object(forKey: "countryCode") as? String ?? "")"
                                                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                }else{
                                                    //defaults.set("123456", forKey: kAuthToken)
                                                    strongSelf.pushHomeController()
                                                }
                                            }
                                        }) { (error) in
                                            
                                            DispatchQueue.main.async {
                                                
                                                GlobalData.shared.hideProgress()
                                                CometChatSnackBoard.display(message:  error?.errorCode.localized() ?? "", mode: .error, duration: .short)
                                                
                                                //                                                strongSelf.pushHomeController()
                                            }
                                        }
                                    }
                                    
//                                    print("Comet login failure \(error.errorDescription)")
//                                    GlobalData.shared.hideProgress()
//                                    DispatchQueue.main.async {
//                                        CometChatSnackBoard.display(message:  error.errorCode.localized(), mode: .error, duration: .short)
//                                        strongSelf.btnLogin.isUserInteractionEnabled = true
//                                        //                                                strongSelf.pushHomeController()
//                                    }
                                    
                                    
                                }
                            }
                        }
                        //                        }else{
                        
//                                                    if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
//                                                        strongSelf.navigationController?.pushViewController(controller, animated: true)
//                                                    }
                        //                        }
                        
                    }else{
                        if let message = response["validationError"] as? NSDictionary {
                            GlobalData.shared.showDarkStyleToastMesage(message: message.getApiErrorMessage())
                        }
                    }
                    
                    
                case .failed(let errorMessage):
                    
                    
                    
                    switch errorMessage {
                    default:
                        self.handleDefaultResponse(errorMessage: errorMessage)
                        break
                    }
                }
            }
        }
        
        //
        //            AFWrapper.shared.requestPOSTURL(Constants.URLS.LOGIN, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
        //                guard let strongSelf = self else { return }
        //
        //                if JSONResponse != JSON.null {
        //                    if let response = JSONResponse.rawValue as? [String : Any] {
        //                        if response["status"] as? Int ?? 0 == successCode {
        //
        //                            GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
        //
        //                            let userDetail = response["data"] as! Dictionary<String, Any>
        //                            let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
        //
        //                            if let data = try? JSONEncoder().encode(object) {
        //
        //                                if strongSelf.imgRemember.image == UIImage.init(named: "ic_check") {
        //                                    defaults.set(true, forKey: kRememberMe)
        //                                    defaults.set(strongSelf.txtEmail.text ?? "", forKey: kRememberEmail)
        //                                    defaults.set(strongSelf.txtPassword.text ?? "", forKey: kRememberPassword)
        //                                } else {
        //                                    defaults.set(false, forKey: kRememberMe)
        //                                }
        //
        //                                defaults.set(data, forKey: kLoggedInUserData)
        //                                defaults.set("\(userDetail["accessToken"] ?? "")", forKey: kAuthToken)
        //                                defaults.synchronize()
        //
        //                                objUserDetail = object
        //
        //                                //                                DispatchQueue.main.async {
        //                                //                                    GlobalData.shared.hideProgress()
        //                                //                                    strongSelf.btnLogin.isUserInteractionEnabled = true
        //                                //                                    strongSelf.pushHomeController()
        //                                //                                }
        //                                //
        //                                DispatchQueue.global().async {
        //
        //                                    CometChat.login(UID: objUserDetail._id, apiKey: Constants.CometChat.authKey, onSuccess: { (current_user) in
        //
        //                                        DispatchQueue.main.async {
        //                                            GlobalData.shared.hideProgress()
        //                                            strongSelf.btnLogin.isUserInteractionEnabled = true
        //                                            //                                                strongSelf.pushHomeController()
        //
        //                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
        //                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
        //                                            }
        //
        //                                        }
        //
        //                                    }) { (error) in
        //                                        print("Comet login failure \(error.errorDescription)")
        //                                        GlobalData.shared.hideProgress()
        //                                        DispatchQueue.main.async {
        //                                            CometChatSnackBoard.display(message:  error.errorCode.localized(), mode: .error, duration: .short)
        //                                            strongSelf.btnLogin.isUserInteractionEnabled = true
        //                                            //                                                strongSelf.pushHomeController()
        //                                        }
        //                                    }
        //                                }
        //
        //
        //
        //                            }
        //                        }
        //                        else if response["status"] as? Int ?? 0 == invalidTokenCode {
        //                            GlobalData.shared.hideProgress()
        //                            strongSelf.btnLogin.isUserInteractionEnabled = true
        //                            GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
        //                        }
        //                        else {
        //                            GlobalData.shared.hideProgress()
        //                            GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
        //                            strongSelf.btnLogin.isUserInteractionEnabled = true
        //                        }
        //                    }
        //                }
        //            }) { (error) in
        //                GlobalData.shared.hideProgress()
        //                GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        //                self.btnLogin.isUserInteractionEnabled = true
        //            }
        //        }
    }
    
    func SocailLoginApiCall(_ id : String, type : String) {
        
        var params = ["socialLoginType" : type,"socialLoginId" : id]
        self.socialSigninInfo.id = id
        self.socialSigninInfo.type = type

        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.SOCIAL_LOGIN, parameters: params) { responceget in
            print(responceget)
            
            let strongSelf = self
            GlobalData.shared.hideProgress()
            self.btnLogin.isUserInteractionEnabled = true
            
            switch responceget {
            case .success(let response):
                
                if let getData = response["data"] as? NSDictionary {
                    
                    let mobileVerified = getData.value(forKey: "mobileVerified") as? String
                    GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    
                    //                        if mobileVerified == true {
                    
                    let userDetail = response["data"] as! Dictionary<String, Any>
                    let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                    
                    let accessToken = userDetail["accessToken"] ?? ""
                    
                    if let data = try? JSONEncoder().encode(object) {
                        
                        if strongSelf.imgRemember.image == UIImage.init(named: "ic_check") {
                            defaults.set(true, forKey: kRememberMe)
                            defaults.set(strongSelf.txtEmail.text ?? "", forKey: kRememberEmail)
                            defaults.set(strongSelf.txtPassword.text ?? "", forKey: kRememberPassword)
                        } else {
                            defaults.set(false, forKey: kRememberMe)
                        }
                        
                        defaults.set(data, forKey: kLoggedInUserData)
                        defaults.set(accessToken, forKey: kAuthToken)
                        defaults.synchronize()
                        
                        objUserDetail = object
                        
                        
                        if mobileVerified == "1" {
                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                controller.phonenumber = "\(getData.object(forKey: "mobileNumber") as? String ?? "")"
                                controller.countryCode = "\(getData.object(forKey: "countryCode") as? String ?? "")"
                                strongSelf.navigationController?.pushViewController(controller, animated: true)
                            }
                        }else{
                            //defaults.set("123456", forKey: kAuthToken)
                            strongSelf.pushHomeController()
                        }
                        
                        return
                        
                        //                                DispatchQueue.main.async {
                        //                                    GlobalData.shared.hideProgress()
                        //                                    strongSelf.btnLogin.isUserInteractionEnabled = true
                        //                                    strongSelf.pushHomeController()
                        //                                }
                        //
                        
                        DispatchQueue.global().async {
                            
                            CometChat.login(UID: objUserDetail._id, apiKey: Constants.CometChat.authKey, onSuccess: { (current_user) in
                                
                                DispatchQueue.main.async {
                                    GlobalData.shared.hideProgress()
                                    strongSelf.btnLogin.isUserInteractionEnabled = true
                                    
                                    if mobileVerified == "1" {
                                        if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                            controller.phonenumber = "\(getData.object(forKey: "mobileNumber") as? String ?? "")"
                                            controller.countryCode = "\(getData.object(forKey: "countryCode") as? String ?? "")"
                                            strongSelf.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }else{
                                        //defaults.set("123456", forKey: kAuthToken)
                                        strongSelf.pushHomeController()
                                    }
                                    
                                    //                                        }else{
                                    //                                            strongSelf.pushHomeController
                                    //                                        }
                                    
                                    //                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                    //                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
                                    //                                            }
                                    
                                }
                                
                            }) { (error) in
                                print("Comet login failure \(error.errorDescription)")
                                
                                DispatchQueue.main.async {
                                    strongSelf.btnLogin.isUserInteractionEnabled = true
                                    
                                    let userID = object._id
                                    let userName = object.userName
                                    
                                    //-: Sign up in CometChat
                                    let user = User(uid: userID, name: userName)
                                    
                                    CometChat.createUser(user: user, apiKey: Constants.CometChat.authKey, onSuccess: { (user) in
                                        
                                        DispatchQueue.main.async {
                                            GlobalData.shared.hideProgress()
                                            
                                            if mobileVerified == "1" {
                                                if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                                    controller.phonenumber = "\(getData.object(forKey: "mobileNumber") as? String ?? "")"
                                                    controller.countryCode = "\(getData.object(forKey: "countryCode") as? String ?? "")"
                                                    strongSelf.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }else{
                                                //defaults.set("123456", forKey: kAuthToken)
                                                strongSelf.pushHomeController()
                                            }
                                        }
                                            
                                        
                                        
                                    }) { (error) in
                                        
                                        DispatchQueue.main.async {
                                            
                                            GlobalData.shared.hideProgress()
                                            CometChatSnackBoard.display(message:  error?.errorCode.localized() ?? "", mode: .error, duration: .short)
                                            
                                            //                                                strongSelf.pushHomeController()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //                        }else{
                    
                    //                                                    if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                    //                                                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                    //                                                    }
                    //                        }
                    
                }else{
                    if let message = response["validationError"] as? NSDictionary {
                        GlobalData.shared.showDarkStyleToastMesage(message: message.getApiErrorMessage())
                    }
                }
                
                
            case .failed(let errorMessage):
                let error_Message = "User with this social id does not exists"
                switch errorMessage {
                case .logout(let message):
                    if error_Message == message {
                        self.gotoSignInPage()
                    }else{
                        self.handleDefaultResponse(errorMessage: errorMessage)
                    }

                case .serverError(let message):
                    if error_Message == message {
                        self.gotoSignInPage()
                    }else{
                        self.handleDefaultResponse(errorMessage: errorMessage)
                    }
                case .noContant(let message):
                    if error_Message == message {
                        self.gotoSignInPage()
                    }else{
                        self.handleDefaultResponse(errorMessage: errorMessage)
                    }
                case .noInternet(let message):
                    if error_Message == message {
                        self.gotoSignInPage()
                    }else{
                        self.handleDefaultResponse(errorMessage: errorMessage)
                    }
                }

            }
        }

    }
    
    func pushHomeController() {
        
        DispatchQueue.main.async {
            let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
            let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let navController = UINavigationController.init(rootViewController: controller)
            appDelegate.drawerController.contentViewController = navController
            appDelegate.drawerController.menuViewController = leftMenuVC
            appDelegate.window?.rootViewController = appDelegate.drawerController
        }
        
    }
    
    func gotoSignInPage(){
        let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "UserSignupVC") as! UserSignupVC
        
        controller.socialSigninInfo = self.socialSigninInfo
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - SOCIAL LOGIN METHOD -
import AuthenticationServices

@available(iOS 13.0, *)
//:-  Apple pay
extension LoginVC : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func openApplePaySheet(){
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        GlobalData.shared.showDarkStyleToastMesage(message: error.localizedDescription.description)
        
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        self.socialSigninInfo = SocialSigninInfo()
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account as per your requirement
            // this key is send to server to authenticate user
            let applekey = appleIDCredential.user
            print(applekey)
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            print(appleUserFirstName ?? "")
            let appleUserLastName = appleIDCredential.fullName?.familyName
            print(appleUserLastName ?? "")
            let appleUserEmail = appleIDCredential.email
            print(appleUserEmail ?? "")
            
            self.socialSigninInfo.name = (appleUserFirstName ?? "" + " " + (appleUserLastName ?? ""))
            self.socialSigninInfo.email = appleUserEmail
            
            self.SocailLoginApiCall(applekey, type: "apple")

            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            
        }
    }
    
}
import FBSDKLoginKit
//:- Facebook
extension LoginVC {
    
    private func openFacebookSheet(){
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print("ERROR: Trying to get login results")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    print("Logged in")
                    self.getUserProfile(token: result?.token, userId: result?.token?.userID)
                } else {
                    print("Cancelled")
                }   
            }
        })
        
    }
    
    private func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { [self] _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                
                //
                
                self.socialSigninInfo = SocialSigninInfo()
                
//                self.socialSigninInfo.name = user?.profile?.name
//                self.socialSigninInfo.email = user?.profile?.email
                var id = ""
                // Facebook Id
                if let facebookId = data["id"] as? String {
                    print("Facebook Id: \(facebookId)")
                    id = facebookId
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    //return
                } else {
                    print("Facebook Id: Not exists")
                }
                
                // Facebook First Name
                if let facebookFirstName = data["first_name"] as? String {
                    print("Facebook First Name: \(facebookFirstName)")
                } else {
                    print("Facebook First Name: Not exists")
                }
                
                // Facebook Middle Name
                if let facebookMiddleName = data["middle_name"] as? String {
                    print("Facebook Middle Name: \(facebookMiddleName)")
                } else {
                    print("Facebook Middle Name: Not exists")
                }
                
                // Facebook Last Name
                if let facebookLastName = data["last_name"] as? String {
                    print("Facebook Last Name: \(facebookLastName)")
                } else {
                    print("Facebook Last Name: Not exists")
                }
                
                // Facebook Name
                if let facebookName = data["name"] as? String {
                    print("Facebook Name: \(facebookName)")
                    self.socialSigninInfo.name = facebookName

                } else {
                    print("Facebook Name: Not exists")
                }
                
                // Facebook Profile Pic URL
                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                
                // Facebook Email
                if let facebookEmail = data["email"] as? String {
                    print("Facebook Email: \(facebookEmail)")
                    self.socialSigninInfo.email = facebookEmail
                } else {
                    print("Facebook Email: Not exists")
                }
                
                print("Facebook Access Token: \(token?.tokenString ?? "")")
                if let userID = id as? String,userID.count > 0 {
                    self.SocailLoginApiCall(userID, type: "Facebook")
                }

            } else {
                print("Error: Trying to get user's info")
            }
        }
    }
    
    
}

import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseCore

//:- Google Sign in
extension LoginVC {
    
    func openGoogleSignSheet(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken,
                let userid  = user?.userID
            else {
                return
            }
            print("get userid : \(userid)")
            let name = (user?.profile?.name)
            let email = (user?.profile?.email)
            print(name,email)
            
            self.socialSigninInfo = SocialSigninInfo()
            
            self.socialSigninInfo.name = user?.profile?.name
            self.socialSigninInfo.email = user?.profile?.email

            SocailLoginApiCall(userid, type: "google")
            //IsGoogleSignOut()
        }
        
        func IsGoogleSignOut(){
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
            
        }
        
    }
}


//:- Twitter Sign in
import TwitterKit
extension LoginVC {
    
    func openTwitterSignSheet() {
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                
                self.socialSigninInfo = SocialSigninInfo()
                self.socialSigninInfo.name = session?.userName
//                self.socialSigninInfo.email = session?.value(forKey: "email") as? String ?? ""
                var id = session?.userID

                if let userID = id as? String,userID.count > 0 {
                    self.SocailLoginApiCall(userID, type: "twitter")
                }
                
            } else {
                print("error: \(error?.localizedDescription)");
//                error?.localizedDescription
                GlobalData.shared.showDarkStyleToastMesage(message: error?.localizedDescription ?? "")

            }
        })
        
//        self.swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY)
//        self.swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self, success: { accessToken, _ in
//            self.accToken = accessToken
//            self.getUserProfile()
//        }, failure: { error in
//            print("ERROR: Trying to authorize \(error)")
//        })
        
    }
    
//    func getUserProfile() {
//        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: false, success: { json in
//            self.socialSigninInfo = SocialSigninInfo()
//            // Twitter Id
//            var id = ""
//            if let twitterId = json["id_str"].string {
//                print("Twitter Id: \(twitterId)")
//                id = twitterId
//            } else {
//                //self.twitterId = "Not exists"
//            }
//
//            // Twitter Handle
//            if let twitterHandle = json["screen_name"].string {
//                print("Twitter Handle: \(twitterHandle)")
//            } else {
//                //self.twitterHandle = "Not exists"
//            }
//
//            // Twitter Name
//            if let twitterName = json["name"].string {
//                print("Twitter Name: \(twitterName)")
//                self.socialSigninInfo.email = twitterName
//
//            } else {
//                //self.twitterName = "Not exists"
//            }
//
//            // Twitter Email
//            if let twitterEmail = json["email"].string {
//                print("Twitter Email: \(twitterEmail)")
//                self.socialSigninInfo.email = twitterEmail
//            } else {
//                //self.twitterEmail = "Not exists"
//            }
//
//            // Twitter Profile Pic URL
//            if let twitterProfilePic = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) {
//                print("Twitter Profile URL: \(twitterProfilePic)")
//            } else {
//                //self.twitterProfilePicURL = "Not exists"
//            }
//            print("Twitter Access Token: \(self.accToken?.key ?? "Not exists")")
//
//            if let userID = id as? String,userID.count > 0 {
//                self.SocailLoginApiCall(userID, type: "twitter")
//            }
//
//        }) { error in
//            print("ERROR: \(error.localizedDescription)")
//        }
//    }
    
}

//import SafariServices
//extension LoginVC: SFSafariViewControllerDelegate {}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
