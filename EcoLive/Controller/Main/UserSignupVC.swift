//
//  UserSignupVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 07/06/21.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import CountryPickerView
import CometChatPro


class UserSignupVC: UIViewController {
    
    static func getObject()-> UserSignupVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserSignupVC") as? UserSignupVC
        if let vc = vc {
            return vc
        }
        return UserSignupVC()
    }
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    var socialSigninInfo = SocialSigninInfo()
    var strCountryCode = ""
    
    // :- Note For Twitter
    //    var swifter: Swifter!
    //    var accToken: Credential.OAuthAccessToken?
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let info = socialSigninInfo as? SocialSigninInfo, info != nil {
            if let name = info.name {
                txtName.text = name
            }
            if let email = info.email {
                txtEmail.text = email
            }
        }
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        self.countryPicker.delegate = self
        self.countryPicker.showCountryCodeInView = false
        self.countryPicker.showPhoneCodeInView = true
        self.countryPicker.showCountryNameInView = false
        self.countryPicker.font = UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 16.0)!
        self.countryPicker.textColor = UIColor.init(hex: 0x333333)
        self.countryPicker.flagSpacingInView = 0.0
        let country = self.countryPicker.selectedCountry
        self.strCountryCode = country.phoneCode
        
        let attString = GlobalData.shared.convertStringtoAttributedText(strFirst: "Already have an account?" + " ", strFirstFont: UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: (self.btnSignin.titleLabel?.font.pointSize)!)!, strFirstColor: UIColor.init(rgb: 0x333333), strSecond: "Sign in", strSecondFont: UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: (self.btnSignin.titleLabel?.font.pointSize)!)!, strSecondColor: UIColor.init(rgb: 0x3663F5))
        self.btnSignin.setAttributedTitle(attString, for: .normal)
        
        DispatchQueue.main.async {
            
            self.viewName.layer.cornerRadius = self.viewName.frame.height / 2.0
            self.viewName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewName.layer.borderWidth = 1.0
            
            self.viewLastName.layer.cornerRadius = self.viewName.frame.height / 2.0
            self.viewLastName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewLastName.layer.borderWidth = 1.0
            
            self.viewEmail.layer.cornerRadius = self.viewEmail.frame.height / 2.0
            self.viewEmail.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewEmail.layer.borderWidth = 1.0
            
            self.viewPassword.layer.cornerRadius = self.viewPassword.frame.height / 2.0
            self.viewPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPassword.layer.borderWidth = 1.0
            
            self.viewConfirmPassword.layer.cornerRadius = self.viewConfirmPassword.frame.height / 2.0
            self.viewConfirmPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewConfirmPassword.layer.borderWidth = 1.0
            
            self.viewPhone.layer.cornerRadius = self.viewPhone.frame.height / 2.0
            self.viewPhone.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPhone.layer.borderWidth = 1.0
            
            self.btnSignup.layer.cornerRadius = self.btnSignup.frame.height / 2.0
            self.btnSignup.createButtonShadow()
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCountryClick(_ sender: UIButton) {
        self.countryPicker.showCountriesList(from: self)
    }
    
    @IBAction func btnSignupClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let phonetrimmedString = self.txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "First name is required")
        }
        else  if self.txtName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Last name is required")
        }
        else if self.txtEmail.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
        }
        else if !self.txtEmail.isValidEmail() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
        }
        else if self.txtPassword.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Password is required")
        }
        else if !Validator.minLength(6).apply(self.txtPassword.text!) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Password should be 6 character long")
        }
        else if self.txtConfirmPassword.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Confirm password is required")
        }
        else if self.txtPassword.text != self.txtConfirmPassword.text {
            GlobalData.shared.showDarkStyleToastMesage(message: "Password and confirm password is not same")
        }
        else if self.strCountryCode == "" {
            GlobalData.shared.showDarkStyleToastMesage(message: "Country code is required")
        }
        else if self.txtPhone.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is required")
        }
        else if !self.txtPhone.isValidPhone() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is invalid")
        }
        else if !Validator.minLength(10).apply(phonetrimmedString) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number should be 10 character long")
        }
        else {
            self.btnSignup.isUserInteractionEnabled = false
            self.callUserSignupAPI()
        }
        
    }
    
    @IBAction func btnSigninClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.navigationController?.popToViewController(ofClass: LoginVC.self, animated: true)
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
}

//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension UserSignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension UserSignupVC: UITextFieldDelegate {
    
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

extension UserSignupVC {
    
    func callUserSignupAPI() {
        
        //        if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
        //
        //        return
        DispatchQueue.global().async {
            
            DispatchQueue.main.async { [self] in
                
                if GlobalData.shared.checkInternet() == false {
                    GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
                    return
                }
                
                //        var deviceToken: String = "123456"
                //        if defaults.value(forKey: "deviceToken") != nil {
                //            deviceToken = defaults.value(forKey: "deviceToken") as! String
                //        }
                
                var params: [String:Any] = [:]
//                params["fullName"] = self.txtName.text ?? ""
                params["firstName"] = self.txtName.text ?? ""
                params["lastName"] = self.txtLastName.text ?? ""
                params["email"] = self.txtEmail.text ?? ""
                params["password"] = self.txtPassword.text ?? ""
                params["countryCode"] = self.strCountryCode
                params["mobileNumber"] = self.txtPhone.text ?? ""
                params["userType"] = "user"
                params["deviceType"] = kDeviceType
                params["deviceId"] = kDeviceId
                //        params["deviceToken"] = deviceToken
                params["fcmToken"] = kDeviceFCMTokan
                params["loginType"] = "normal"
                params["latitude"] =  ""
                params["longitude"] =  ""
                
                if let info = socialSigninInfo as? SocialSigninInfo, info != nil {
                    params["socialLoginType"] =  info.type
                    params["socialLoginId"] =  info.id
                }
                
                GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
                
                DispatchQueue.main.async {
                    
                    NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.SIGNUP, parameters: params) { responce in
                        print(responce)
                        GlobalData.shared.hideProgress()
                        let strongSelf = self
                        
                        switch responce {
                        case .success(let jsondata):
                            
                            if let data = jsondata["data"] as? NSDictionary {
                                
                                guard let userID = data.value(forKey: "_id") as? String else { return }
                                guard let userName = data.value(forKey: "firstName") as? String else { return }
                                
                                // -: Sign up in CometChat
                                let user = User(uid: userID, name: userName)
                                
                                DispatchQueue.main.async {
                                    
                                    strongSelf.btnSignup.isUserInteractionEnabled = true
                                    
                                    GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))
                                    
                                    if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                        controller.phonenumber = self.txtPhone.text ?? ""
                                        controller.countryCode = self.strCountryCode
                                        strongSelf.navigationController?.pushViewController(controller, animated: true)
                                    }
                                    return
                                    
                                    //                            DispatchQueue.main.async {
                                    //
                                    //
                                    //                            CometChat.createUser(user: user, apiKey: Constants.CometChat.authKey, onSuccess: { (user) in
                                    //
                                    //                                if let uid = user.uid {
                                    //
                                    //                                    DispatchQueue.global().async {
                                    //
                                    //                                    CometChat.login(UID: uid, apiKey: Constants.CometChat.authKey, onSuccess: { (current_user) in
                                    //
                                    //                                        DispatchQueue.main.async {
                                    //                                            GlobalData.shared.hideProgress()
                                    //                                            strongSelf.btnSignup.isUserInteractionEnabled = true
                                    //
                                    //                                            //                                            strongSelf.pushHomeController()
                                    //                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                                    //                                                controller.phonenumber = self.txtPhone.text ?? ""
                                    //                                                controller.countryCode = self.strCountryCode
                                    //                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
                                    //                                            }
                                    //                                        }
                                    //                                    }) { (error) in
                                    //                                        print("Comet login failure \(error.errorDescription)")
                                    //
                                    //
                                    //                                        DispatchQueue.main.async {
                                    //
                                    //                                            strongSelf.btnSignup.isUserInteractionEnabled = true
                                    //                                            GlobalData.shared.hideProgress()
                                    //                                            CometChatSnackBoard.display(message:  error.errorCode.localized(), mode: .error, duration: .short)
                                    //                                            strongSelf.btnSignup.isUserInteractionEnabled = true
                                    //                                            strongSelf.pushHomeController()
                                    //                                        }
                                    //                                    }
                                    //                                    }
                                    //                                }
                                    //                            }) { (error) in
                                    //
                                    //                                DispatchQueue.main.async {
                                    //
                                    //                                    if let error = error?.errorDescription {
                                    //                                        print("Create Comet User failure \(error)")
                                    //                                        GlobalData.shared.hideProgress()
                                    //                                        CometChatSnackBoard.display(message:  error, mode: .error, duration: .short)
                                    //                                    }
                                    //
                                    //                                    strongSelf.btnSignup.isUserInteractionEnabled = true
                                    ////                                    strongSelf.pushHomeController()
                                    //                                }
                                    //                            }
                                    //                            }
                                }
                                
                            }else{
                                if let message = jsondata["validationError"] as? NSDictionary {
                                    GlobalData.shared.showDarkStyleToastMesage(message: message.getApiErrorMessage())
                                }
                            }
                            
                            
                        case .failed(let errorMessage):
                            strongSelf.btnSignup.isUserInteractionEnabled = true
                            switch errorMessage {
                            default:
                                self.handleDefaultResponse(errorMessage: errorMessage)
                                break
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
        
        //        AFWrapper.shared.requestPOSTURL(Constants.URLS.SIGNUP, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
        //            guard let strongSelf = self else { return }
        //
        //            if JSONResponse != JSON.null {
        //                if let response = JSONResponse.rawValue as? [String : Any] {
        //                    if response["status"] as? Int ?? 0 == successCode {
        //
        //                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
        //
        //                        let userDetail = response["data"] as! Dictionary<String, Any>
        //                        let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
        //
        //                        if let data = try? JSONEncoder().encode(object) {
        //                            defaults.set(data, forKey: kLoggedInUserData)
        //                            defaults.set("\(userDetail["accessToken"] ?? "")", forKey: kAuthToken)
        //                            defaults.synchronize()
        //
        //                            objUserDetail = object
        //
        //                            let user = User(uid: objUserDetail._id, name: objUserDetail.userName)
        //                            CometChat.createUser(user: user, apiKey: Constants.CometChat.authKey, onSuccess: { (user) in
        //
        //                                if let uid = user.uid {
        //                                    CometChat.login(UID: uid, apiKey: Constants.CometChat.authKey, onSuccess: { (current_user) in
        //
        //                                        DispatchQueue.main.async {
        //                                            GlobalData.shared.hideProgress()
        //                                            strongSelf.btnSignup.isUserInteractionEnabled = true
        ////                                            strongSelf.pushHomeController()
        //                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
        //                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
        //                                            }
        //                                        }
        //                                    }) { (error) in
        //                                        print("Comet login failure \(error.errorDescription)")
        //                                        GlobalData.shared.hideProgress()
        //
        //                                        DispatchQueue.main.async {
        //                                            CometChatSnackBoard.display(message:  error.errorCode.localized(), mode: .error, duration: .short)
        //                                            strongSelf.btnSignup.isUserInteractionEnabled = true
        //                                            strongSelf.pushHomeController()
        //                                        }
        //                                    }
        //                                }
        //                            }) { (error) in
        //                                if let error = error?.errorDescription {
        //                                    print("Create Comet User failure \(error)")
        //                                    GlobalData.shared.hideProgress()
        //                                    CometChatSnackBoard.display(message:  error, mode: .error, duration: .short)
        //                                }
        //
        //                                DispatchQueue.main.async {
        //                                    strongSelf.btnSignup.isUserInteractionEnabled = true
        //                                    strongSelf.pushHomeController()
        //                                }
        //                            }
        //                        }
        //                    }
        //                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
        //                        GlobalData.shared.hideProgress()
        //                        strongSelf.btnSignup.isUserInteractionEnabled = true
        //                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
        //                    }
        //                    else {
        //                        GlobalData.shared.hideProgress()
        //                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
        //                        strongSelf.btnSignup.isUserInteractionEnabled = true
        //                    }
        //                }
        //            }
        //        }) { (error) in
        //            GlobalData.shared.hideProgress()
        //            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        //            self.btnSignup.isUserInteractionEnabled = true
        //        }
    }
    
    func pushHomeController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
    
    func SocailLoginApiCall(_ id : String, type : String) {
        
        socialSigninInfo.id = id
        socialSigninInfo.type = type
        
        if let info = socialSigninInfo as? SocialSigninInfo, info != nil {
            txtName.text = info.name
            txtEmail.text = info.email
        }
        
    }
    
    
    
}


//MARK: - SOCIAL LOGIN METHOD -
import AuthenticationServices

@available(iOS 13.0, *)
//:-  Apple pay
extension UserSignupVC : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
            print(appleUserFirstName)
            let appleUserLastName = appleIDCredential.fullName?.familyName
            print(appleUserLastName)
            let appleUserEmail = appleIDCredential.email
            print(appleUserEmail)
            
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
extension UserSignupVC {
    
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
extension UserSignupVC {
    
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

//import Swifter
//:- Twitter Sign in
extension UserSignupVC {
    
    func openTwitterSignSheet() {
        
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                
                self.socialSigninInfo = SocialSigninInfo()
                self.socialSigninInfo.name = session?.userName
                //                self.socialSigninInfo.email = session?.value(forKey: "email") as? String ?? ""
                let id = session?.userID
                
                if let userID = id as? String,userID.count > 0 {
                    self.SocailLoginApiCall(userID, type: "twitter")
                }
                
            } else {
                print("error: \(error?.localizedDescription)");
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
//extension UserSignupVC: SFSafariViewControllerDelegate {}
