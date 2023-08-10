//
//  ForgotPasswordVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 11/06/21.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import CountryPickerView

class ForgotPasswordVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var countryPicker: CountryPickerView!
    
    var strCountryCode = ""

    
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
            
            self.countryPicker.delegate = self
            self.countryPicker.showCountryCodeInView = false
            self.countryPicker.showPhoneCodeInView = true
            self.countryPicker.showCountryNameInView = false
            self.countryPicker.font = UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 16.0)!
            self.countryPicker.textColor = UIColor.init(hex: 0x333333)
            self.countryPicker.flagSpacingInView = 0.0
            let country = self.countryPicker.selectedCountry
            self.strCountryCode = country.phoneCode
            
            self.viewEmail.layer.cornerRadius = self.viewEmail.frame.height / 2.0
            self.viewEmail.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewEmail.layer.borderWidth = 1.0
            
            self.viewPhone.layer.cornerRadius = self.viewPhone.frame.height / 2.0
            self.viewPhone.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPhone.layer.borderWidth = 1.0
            
            self.btnForgotPassword.layer.cornerRadius = self.btnForgotPassword.frame.height / 2.0
            self.btnForgotPassword.createButtonShadow()
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnSelectCountryClick(_ sender: UIButton) {
        self.countryPicker.showCountriesList(from: self)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let phonetrimmedString = self.txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        if self.strCountryCode == "" {
            GlobalData.shared.showDarkStyleToastMesage(message: "Country code is required")
        }else  if self.txtPhone.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is required")
        }else if !self.txtPhone.isValidPhone() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is invalid")
        }
        else if !Validator.minLength(10).apply(phonetrimmedString) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number should be 10 character long")
        }else{
            //api
            sendOTPApi()
        }

        
//        if self.txtEmail.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
//        }
//        else if !self.txtEmail.isValidEmail() {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
//        }
//        else {
//            self.callForgotPasswordAPI()
//        }
    }
}


//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension ForgotPasswordVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension ForgotPasswordVC: UITextFieldDelegate {
    
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

extension ForgotPasswordVC {
    
    func sendOTPApi(){
        
        let parm = ["mobileNumber": txtPhone.text?.trimmingCharacters(in: .whitespaces) ?? "",
                    "countryCode": strCountryCode,
                    "sendOtpType" : "forgetpassword"]
        
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
                
                GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                
                let userDetail = response["data"] as! Dictionary<String, Any>
                
                if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
                    controller.oTPScreenType = .resetPassword
                    controller.phonenumber = self.txtPhone.text ?? ""
                    controller.countryCode = self.strCountryCode
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
}

    
//    func callForgotPasswordAPI() {
//        debugPrint("API CALL")
//        self.view.endEditing(true)
//
//        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
//
//
//        DispatchQueue.main.async {
//            NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.USER_RESET_PASSWORD, parameters: params) { responceget in
//                print(responceget)
//
//                let strongSelf = self
//                GlobalData.shared.hideProgress()
//                self.btnLogin.isUserInteractionEnabled = true
//
//                switch responceget {
//                case .success(let response):
//
//                    GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
//
//
//                    if let getData = response["data"] as? NSDictionary {
//
//                        if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
//                            controller.oTPScreenType = .resetPassword
//                            navigationController?.pushViewController(controller, animated: true)
//                        }
//
//                    }
//
//                case .failed(let errorMessage):
//
//                    switch errorMessage {
//                    default:
//                        self.handleDefaultResponse(errorMessage: errorMessage)
//                        break
//                    }
//                }
//            }
//
//
//
//        //self.navigationController?.popViewController(animated: true)
//    }
//}
