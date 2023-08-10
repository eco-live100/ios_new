//
//  OTPViewController.swift
//  NightOut
//
//  Created by Ajit Jain on 21/07/21.
//

import UIKit
import OTPFieldView
import SROTPView

enum OTPScreenType {
    case normal
    case resetPassword
}

class OTPViewController: BaseVC ,UITextFieldDelegate{
    
    static func getObject()-> OTPViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
        if let vc = vc {
            return vc
        }
        return OTPViewController()
    }
    
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblDonot: UILabel!
    @IBOutlet weak var lblVarifyNumber: UILabel!
    @IBOutlet weak var otpView: SROTPView!
    @IBOutlet weak var otpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    fileprivate let OTP_CELL_SPACING: CGFloat = 13
    
    var phonenumber = ""
    var countryCode = ""
    var email = ""
    var otppin = ""
    
    var isFromEmailVerify:Bool = false
    
    var timer: Timer?
    var totalTime = 30
    
    //    var otpTimer =  Timer()
    //    var counter = 30
    
    var oTPScreenType : OTPScreenType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromEmailVerify{
            self.sendEmailOtpApi()
        }else{
            if oTPScreenType != .resetPassword {
                resendOtpApi()
            }else{
                self.setupOtpview()
                self.otppin = ""
                self.startOtpTimer()
            }
        }
        
      
        
        if phonenumber != ""{
            let first2 = phonenumber[0 ..< 2]
            let last2 = phonenumber[(phonenumber.count - 2) ..< phonenumber.count]
            self.lblVarifyNumber.text = "Please Enter the Verification Code sent to Mobile No : +44 \(first2 + "********" + last2)"
        }
        self.setupOtpview()
        
        
//        setupOtpView()
//        self.startOtpTimer()
//        SocketManager.shared.connectSocket(notify: true)
//        SocketManager.shared.registerToScoket(observer: self)
        
        DispatchQueue.main.async {
            self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.height / 2.0
            self.btnSubmit.createButtonShadow()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func didTapGoBack(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func didtapResendButton(_ sender: UIButton) {
        self.timer?.invalidate()
        self.resendOtpApi()
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if otppin.count < 5 {
            self.view.makeToast("Please enter otp")
        }else if (isFromEmailVerify){
            self.apiEmailVerifyOtp()
        } else {
            self.apiVerifyOtp()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //SocketManager.shared.unregisterToSocket(observer: self)
    }
    
    func pushHomeController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
    
    func pushLoginController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
        
    }
    
}




extension OTPViewController{
    private func startOtpTimer() {
        self.totalTime = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        btnResend.isHidden = true
        lblDonot.isHidden = true
        lblCounter.isHidden = false
        
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        self.lblCounter.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                btnResend.isHidden = false
                lblDonot.isHidden = false
                lblCounter.isHidden = true
                self.timer = nil
            }
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setupOtpview(){
        let cellWidth: CGFloat = (Constants.ScreenSize.SCREEN_WIDTH / CGFloat(6.0)) - self.OTP_CELL_SPACING-5
        // self.otpViewHeightConstraint.constant = cellWidth
        otpView.otpTextFieldsCount  = 6
        otpView.otpTextFieldFontColor = .black
        otpView.size = cellWidth
        otpView.space = 10
        
        otpView.otpTextFieldActiveBorderColor = UIColor.lightGray
        otpView.otpTextFieldDefaultBorderColor = UIColor.lightGray
        
        otpView.activeHeight = 1
        otpView.inactiveHeight = 1
        otpView.otpType = .Bordered//.Rounded
        
        otpView.otpTextFieldActiveBorderColor = UIColor.clear
        otpView.otpTextFieldDefaultBorderColor = UIColor.clear
        otpView.textBackgroundColor = .white
        otpView.otpTextFieldFontColor = .black
        otpView.becomeFirstResponder()
        otpView.tintColor = .black
        
        otpView.otpEnteredString = { pin in
            print("The entered pin is \(pin)")
            
            if pin.count == 6 {
                self.otppin = pin
            }
        }
        otpView.setUpOtpView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("change")
        return true
    }
    
    
    //    func setupOtpView(){
    //            let cellWidth: CGFloat = (Constants.SCREEN_WIDTH / CGFloat(4.0)) - 40
    //                self.otpViewHeightConstraint.constant = cellWidth
    //            self.otpTextFieldView.fieldsCount = 4
    ////            self.otpTextFieldView.fieldBorderWidth = 2
    //            self.otpTextFieldView.defaultBorderColor = UIColor.clear
    //        self.otpTextFieldView.defaultBackgroundColor = .white
    //            self.otpTextFieldView.filledBorderColor = UIColor.clear
    //        self.otpTextFieldView.filledBackgroundColor = UIColor.white
    //
    //        self.otpTextFieldView.backgroundColor = UIColor.clear
    //        self.otpTextFieldView.cursorColor = UIColor.black
    //        self.otpTextFieldView.displayType = .roundedCorner
    //            self.otpTextFieldView.fieldSize = cellWidth
    //            self.otpTextFieldView.separatorSpace = 10
    //        otpTextFieldView.displayType = .roundedCorner
    //            self.otpTextFieldView.shouldAllowIntermediateEditing = false
    //            self.otpTextFieldView.delegate = self
    //            self.otpTextFieldView.initializeUI()
    //        }
}


//extension OTPViewController: OTPFieldViewDelegate {
//    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
//        print("Has entered all OTP? \(hasEntered)")
//        return false
//    }
//
//    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
//        return true
//    }
//
//    func enteredOTP(otp otpString: String) {
//        print("OTPString: \(otpString)")
//    }
//}

extension OTPViewController{
    func apiVerifyOtp(){
        var parm = ["mobileNumber": phonenumber,
                    "otpCode": otppin,
                    "verifyOtpType": "normal",
        ] as [String : Any]
        
        if oTPScreenType == .resetPassword {
            parm["verifyOtpType"] = "forgetpassword"
        }
        print(parm)
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.VERIFYMOBILEOTP, parameters: parm) {
            (resStatus) in
            GlobalData.shared.hideProgress()
            self.otppin = ""
            switch resStatus {
            case .failed(let errorMessage ):
                self.setupOtpview()
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            case .success(let response ):
                self.setupOtpview()
                
                self.timer?.invalidate()
                GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                
                let userDetail = response["data"] as! Dictionary<String, Any>
                
                if self.oTPScreenType == .resetPassword {
                    
                    // go to new screen add new password
                    if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "CreateNewPassword") as? CreateNewPassword {
                        controller.userId = userDetail["_id"] as? String ?? ""
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    
                } else {
                    
                    let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                    
                    if let data = try? JSONEncoder().encode(object) {
                        let accessToken = userDetail["accessToken"] ?? ""
                        defaults.set(data, forKey: kLoggedInUserData)
                        defaults.set(accessToken, forKey: kAuthToken)
                        defaults.synchronize()
                        objUserDetail = object
                    }
                    
                    let controller =  OptionSignupVC.getObject()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func apiEmailVerifyOtp(){
        let parm = ["otpCode": otppin] as [String : Any]
        print(parm)
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
    
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.VERIFYEMAILOTP, parameters: parm) {
            (resStatus) in
            GlobalData.shared.hideProgress()
            self.otppin = ""
            switch resStatus {
            case .failed(let errorMessage ):
                self.setupOtpview()
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            case .success(let response ):
                self.setupOtpview()
                self.timer?.invalidate()
                GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                let userDetail = response["data"] as! Dictionary<String, Any>
                print(userDetail)
                self.isFromEmailVerify = false
                self.pop()
            }
        }
    }
    
    
    func resendOtpApi(){
        
        var parm = ["mobileNumber": phonenumber,
                    "countryCode": countryCode,
                    "sendOtpType" : "normal"
                    
        ] as [String : Any]
        
        if oTPScreenType == .resetPassword {
            parm["verifyOtpType"] = "forgetpassword"
        }
        
        print(parm)
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.SENDMOBILEOTP, parameters: parm) {
            (resStatus) in
            
            GlobalData.shared.hideProgress()
            
            switch resStatus {
            case .failed(let errorMessage ):
                
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            case .success(let response ):
                let isSuccess = response["statusCode"] as? Int ?? 0
                if(isSuccess == 200){
                    self.setupOtpview()
                    self.otppin = ""
                    self.startOtpTimer()
                    // print(response)
                    self.view.makeToast(response["message"] as? String)
                }
            }
        }
    }
    
    func sendEmailOtpApi(){
        
//        var parm = ["mobileNumber": phonenumber,
//                    "countryCode": countryCode,
//                    "sendOtpType" : "normal"
//        ] as [String : Any]
        
        let parm: [String:Any] = [:]
        print(parm)
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.SENDEMAILOTP, parameters: parm) {
            (resStatus) in
            
            GlobalData.shared.hideProgress()
            
            switch resStatus {
            case .failed(let errorMessage ):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            case .success(let response ):
                let isSuccess = response["statusCode"] as? Int ?? 0
                if(isSuccess == 200){
                    self.setupOtpview()
                    self.otppin = ""
                    self.startOtpTimer()
                    self.view.makeToast(response["message"] as? String)
                }
            }
        }
    }
    
    
    //    func socketSetup(){
    //
    //        self.showLoader()
    //        let url = "\(obj.prefs.value(forKey: App_Default_Img_Path) as? String ?? "")/\(obj.prefs.value(forKey: App_User_Img) as? String ?? "")"
    //
    //        let messageDictionary = [
    //            "request": "login",
    //            "userId": LoginUserModel.shared.id,
    //            "type": "loginOrCreate",// userModified
    //            "fcm_token": LoginUserModel.shared.fCMToken,
    //            "userName": "nightoutapp@gmail.com",//(obj.prefs.value(forKey: USER_NAME) as? String ?? ""),
    //            "firstName": (obj.prefs.value(forKey: USER_NAME_FIRST) as? String ?? ""),
    //            "password":  "123456",
    //            "profile_pic" : url//url
    //        ] as [String : Any]
    //
    //        let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary)
    //        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    //        if let message:String = jsonString as String?{
    //            self.showLoader()
    //            SocketManager.shared.sendMessageToSocket(message: message)
    //            //            socket.write(string: message) //write some Data over the socket!
    //        }
    //
    //    }
}



//extension OTPViewController: SocketObserver {
//
//    func registerFor() -> [ResponseType] {
//        return [.loginOrCreate]
//    }
//
//    func brodcastSocketMessage(to observerWithIdentifire: ResponseType, statusCode: Int, data: [String : Any], message: String) {
//
//        self.hideLoader()
//        print("observerWithIdentifire : *********** \(observerWithIdentifire)")
//
//        if (observerWithIdentifire == .loginOrCreate){
//
//        }
//
//    }
//
//
//    func socketConnection(status: SocketConectionStatus) {
//        print(status)
//    }
//
//
//
//}


