//
//  ShopOwnerSignupVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 08/06/21.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import DropDown
import CountryPickerView
import CometChatPro

class ShopOwnerSignupVC: UIViewController {
    
    static func getObject()-> ShopOwnerSignupVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopOwnerSignupVC") as? ShopOwnerSignupVC
        if let vc = vc {
            return vc
        }
        return ShopOwnerSignupVC()
    }

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
    @IBOutlet weak var viewShopName: UIView!
    @IBOutlet weak var txtShopName: UITextField!
    @IBOutlet weak var viewShopCategory: UIView!
    @IBOutlet weak var txtShopCategory: UITextField!
    @IBOutlet weak var viewShopType: UIView!
    @IBOutlet weak var txtShopType: UITextField!

    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    var shopCategoryDropDown = DropDown()
    var shopTypeDropDown =     DropDown()

    var arrShopCategory: [ShopInfoCategoryObject] = []
    
    var selectedShopCategory = ""
    var selectedShopType = ""

    var strCountryCode = ""
    
    
//    var arrShopTypes: [ShopInfoTypeObject] = []
//    var arrShopCategorys: [ShopInfoCategoryObject] = []

    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDetail()
        self.apiShopCatlist()
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
            
            self.viewShopName.layer.cornerRadius = self.viewShopName.frame.height / 2.0
            self.viewShopName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewShopName.layer.borderWidth = 1.0
            
            self.viewShopCategory.layer.cornerRadius = self.viewShopCategory.frame.height / 2.0
            self.viewShopCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewShopCategory.layer.borderWidth = 1.0
            
            self.viewShopType.layer.cornerRadius = self.viewShopType.frame.height / 2.0
            self.viewShopType.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewShopType.layer.borderWidth = 1.0
            
            self.txtShopCategory.isUserInteractionEnabled = false
            
            self.btnSignup.layer.cornerRadius = self.btnSignup.frame.height / 2.0
            self.btnSignup.createButtonShadow()
        }
        
        //FETCH SHOP CATEGORY DATA
//        if let data = defaults.value(forKey: configurationData) as? Data,
//            let configData = try? JSONDecoder().decode(UtilityObject.self, from: data) {
//            GlobalData.shared.objConfiguration = configData
//
//            self.arrShopCategory = GlobalData.shared.objConfiguration.arrShopCategory
//        }
        
    }
    
    //MARK: - HELPER -
    
    func setupShopCategoryDropDown() {
        
        self.shopCategoryDropDown = DropDown()

        let arrCategory = self.arrShopCategory.map { $0.name }
                
        self.shopCategoryDropDown.backgroundColor = .white
        self.shopCategoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.shopCategoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.shopCategoryDropDown.selectedTextColor = .white
        
        self.shopCategoryDropDown.anchorView = self.viewShopType //shopTypeDropDown
        self.shopCategoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.shopCategoryDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.shopCategoryDropDown.dataSource = arrCategory
        self.shopCategoryDropDown.direction = .bottom
        self.shopCategoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.shopCategoryDropDown.cellHeight = 42
        
//        guard let index = arrCategory.firstIndex(of: self.txtShopCategory.text ?? "Pedestrian") else { return }
//        self.shopCategoryDropDown.selectRow(index, scrollPosition: .top)
        
        self.shopCategoryDropDown.selectionAction = { (index: Int, item: String) in
            self.txtShopType.text = item
            self.selectedShopType = self.arrShopCategory[index]._id
            
            self.txtShopCategory.text = ""
            self.selectedShopCategory = ""
            
            self.setupShopSubCategories()
        }
        
        
    }
    
    func setupShopSubCategories(){
        
        self.shopTypeDropDown = DropDown()
        let arrCategory : [ShopInfoCategorySubObject] = (self.arrShopCategory.filter({ $0.name == self.txtShopType.text ?? ""}).first?.shopInfoCategorySubObject) as? [ShopInfoCategorySubObject] ?? []
        let getCategories = arrCategory.map { $0.name }
        
        self.shopTypeDropDown.backgroundColor = .white
        self.shopTypeDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.shopTypeDropDown.textColor = Constants.Color.THEME_BLACK
        self.shopTypeDropDown.selectedTextColor = .white
        
        self.shopTypeDropDown.anchorView = self.viewShopCategory
        self.shopTypeDropDown.bottomOffset = CGPoint(x: 0, y:((self.shopTypeDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.shopTypeDropDown.dataSource = getCategories
        self.shopTypeDropDown.direction = .bottom
        self.shopTypeDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.shopTypeDropDown.cellHeight = 42
        
        self.shopTypeDropDown.selectionAction = { (index: Int, item: String) in
            self.txtShopCategory.text = item
            self.selectedShopCategory = arrCategory[index]._id
        }
        
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCountryClick(_ sender: UIButton) {
        self.countryPicker.showCountriesList(from: self)
    }
    
    @IBAction func btnShopTypeClick(_ sender: UIButton) {
        self.shopCategoryDropDown.show()
    }
    
    @IBAction func btnShopCetegogoryClick(_ sender: UIButton) {
        self.shopTypeDropDown.show()
    }
   
    
    @IBAction func btnSignupClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
//        let phonetrimmedString = self.txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        if self.txtName.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Name is required")
//        }
//        else if self.txtEmail.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
//        }
//        else if !self.txtEmail.isValidEmail() {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
//        }
//        else if self.txtPassword.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Password is required")
//        }
//        else if !Validator.minLength(6).apply(self.txtPassword.text!) {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Password should be 6 character long")
//        }
//        else if self.txtConfirmPassword.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Confirm password is required")
//        }
//        else if self.txtPassword.text != self.txtConfirmPassword.text {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Password and confirm password is not same")
//        }
//        else if self.strCountryCode == "" {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Country code is required")
//        }
//        else if self.txtPhone.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is required")
//        }
//        else if !self.txtPhone.isValidPhone() {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is invalid")
//        }
//        else if !Validator.minLength(10).apply(phonetrimmedString) {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number should be 10 character long")
//        }
//        else
            
        if self.txtShopName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop name is required")
        } else if self.txtShopType.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop type is required")
        }else if self.txtShopCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop category is required")
        }
        else {
            self.callShopOwnerSignupAPI()
        }
    }
    
    @IBAction func btnSigninClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.navigationController?.popToViewController(ofClass: LoginVC.self, animated: true)
    }
}

//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension ShopOwnerSignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {

        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension ShopOwnerSignupVC: UITextFieldDelegate {
    
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

extension ShopOwnerSignupVC {
    
    func callShopOwnerSignupAPI() {
        
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let parm = ["shopCategoryId" : selectedShopCategory,
                    "shopSubCategoryId" : selectedShopType ,
                    "shopName" : txtShopName.text?.trimmingCharacters(in: .whitespaces)
        ]
        
        self.btnSignup.isUserInteractionEnabled = false

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
//        NetworkManager.callServiceMultipalFiles(url: <#T##String#>, files: <#T##[SSFiles]#>, parameters: parm) { <#NetworkResponseState#> in
//            <#code#>
//        }
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.ADD_VENDOR_SHOP_DETAILS, parameters: parm) { responce in
            print(responce)
            
            GlobalData.shared.hideProgress()
            
            switch responce {
            case .success(let jsondata):

                GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))
                if let payloadData = jsondata["data"] as? NSDictionary {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        objUserDetail.userType = "shop"
//                        self.pushHomeController()
                        self.pushShopOwnerController()
                    }
                }
                
            case .failed(let errorMessage):
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
            
            do {
                self.btnSignup.isUserInteractionEnabled = true
            }
            
        }
        
//        return
//        
//        var deviceToken: String = "123456"
//        if defaults.value(forKey: "deviceToken") != nil {
//            deviceToken = defaults.value(forKey: "deviceToken") as! String
//        }
//        
//        var params: [String:Any] = [:]
//        params["userName"] = self.txtName.text ?? ""
//        params["email"] = self.txtEmail.text ?? ""
//        params["password"] = self.txtPassword.text ?? ""
//        params["countryCode"] = self.strCountryCode
//        params["contactNo"] = self.txtPhone.text ?? ""
//        params["shopName"] = self.txtShopName.text ?? ""
//        params["shopCategory"] = self.selectedShopCategory
//        params["userType"] = "shop"
//        params["loginType"] = "normal"
//        params["deviceType"] = kDeviceType
//        params["deviceToken"] = deviceToken
//        
//        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
//        
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
//                        var accessToken = userDetail["accessToken"] ?? ""
//                        
//                        if let data = try? JSONEncoder().encode(object) {
//                            
//                            defaults.set(data, forKey: kLoggedInUserData)
//                            defaults.set(accessToken, forKey: kAuthToken)
//                            defaults.synchronize()
//                            objUserDetail = object
//                            
//                            DispatchQueue.main.async {
//                                strongSelf.btnSignup.isUserInteractionEnabled = true
//                                strongSelf.pushHomeController()
//                            }
//                            
////                            let user = User(uid: objUserDetail._id, name: objUserDetail.userName)
////                            CometChat.createUser(user: user, apiKey: Constants.CometChat.authKey, onSuccess: { (user) in
////
////                                if let uid = user.uid {
////                                    CometChat.login(UID: uid, apiKey: Constants.CometChat.authKey, onSuccess: { (current_user) in
////
////                                        DispatchQueue.main.async {
////                                            GlobalData.shared.hideProgress()
////                                            strongSelf.btnSignup.isUserInteractionEnabled = true
//////                                            strongSelf.pushHomeController()
////                                            if let controller = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
////                                                strongSelf.navigationController?.pushViewController(controller, animated: true)
////                                            }
////                                        }
////                                    }) { (error) in
////                                        print("Comet login failure \(error.errorDescription)")
////                                        GlobalData.shared.hideProgress()
////
////                                        DispatchQueue.main.async {
////                                            CometChatSnackBoard.display(message:  error.errorCode.localized(), mode: .error, duration: .short)
////                                            strongSelf.btnSignup.isUserInteractionEnabled = true
////                                            strongSelf.pushHomeController()
////                                        }
////                                    }
////                                }
////                            }) { (error) in
////                                if let error = error?.errorDescription {
////                                    print("Create Comet User failure \(error)")
////                                    GlobalData.shared.hideProgress()
////                                    CometChatSnackBoard.display(message:  error, mode: .error, duration: .short)
////                                }
////
////                                DispatchQueue.main.async {
////                                    strongSelf.btnSignup.isUserInteractionEnabled = true
////                                    strongSelf.pushHomeController()
////                                }
////                            }
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
    
    func apiShopCatlist(){
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_SHOP_CATEGORIES_LIST, parameters: [:]) { responce in
            print(responce)
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                print(jsondata)
                if let shopTypeList = jsondata["data"] as? NSArray {
                    
                        for i in 0..<shopTypeList.count {
                            let objData = ShopInfoCategoryObject.init(shopTypeList[i] as! [String : Any])
                            self.arrShopCategory.append(objData)
                        }
                        
                        self.setupShopCategoryDropDown()
//
                    
//                    if let vehicleCategory = payloadData["vehicleCategory"] as? NSArray {
//
//                        for i in 0..<vehicleCategory.count  {
//                            let objData = ProductCategoryObjectNew.init(vehicleCategory[i] as! [String : Any])
//                            //self.arrVehicleCategory.append(objData)
//                        }
//                    }
//                    if let vehicleType = payloadData["vehicleType"] as? NSArray {
//                        for i in 0..<vehicleType.count  {
//                            let objData = ProductTypeObjectNew.init(vehicleType[i] as! [String : Any])
//                            //self.arrVehicleType.append(objData)
//                        }
//                    }
                    
                    //self.setupCategoryDropDown()
                    
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
    
    func pushHomeController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
    
    func pushShopOwnerController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopDetailVC") as! ShopDetailVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
}
