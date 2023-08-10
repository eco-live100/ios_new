//
//  RiderSignupVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 07/06/21.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import CountryPickerView

class RiderSignupVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
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
            
            self.btnNext.layer.cornerRadius = self.btnNext.frame.height / 2.0
            self.btnNext.createButtonShadow()
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
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let phonetrimmedString = self.txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Name is required")
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
            let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "VehicleInformationVC") as! VehicleInformationVC
            controller.strName = self.txtName.text ?? ""
            controller.strEmail = self.txtEmail.text ?? ""
            controller.strPassword = self.txtPassword.text ?? ""
            controller.strCountryCode = self.strCountryCode
            controller.strPhoneNo = self.txtPhone.text ?? ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func btnSigninClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.navigationController?.popToViewController(ofClass: LoginVC.self, animated: true)
    }
}

//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension RiderSignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {

        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension RiderSignupVC: UITextFieldDelegate {
    
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
