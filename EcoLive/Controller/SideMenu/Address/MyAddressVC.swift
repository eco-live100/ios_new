//
//  MyAddressVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 09/06/21.
//

import UIKit
import SwiftValidators
import DLRadioButton
import SwiftyJSON
import GooglePlaces

enum ADDRESS_TYPE : String {
    case HOME    = "Home"
    case OFFICE  = "Office"
}

class MyAddressVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var viewAddressType: UIView!
    @IBOutlet var btnAddressType: DLRadioButton!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    var addressType = ""
    var lat = 0.0
    var lng = 0.0
    var arrAddress: [AddressObject] = []
    
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
        
        self.btnAddressType.isMultipleSelectionEnabled = false

        txtAddress.delegate = self
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            self.viewAddressType.createButtonShadow()

            self.btnAdd.layer.cornerRadius = self.btnAdd.frame.height / 2.0
            self.btnAdd.createButtonShadow()
        }
        
        if self.arrAddress.count > 0 {
            let objFirstData = self.arrAddress[0]
            
            self.txtFullName.text = objFirstData.userName
            self.txtMobile.text = objFirstData.userContact
            self.txtAddress.text = objFirstData.userAddresssLine1
            self.txtPincode.text = objFirstData.userPincode
            self.txtCity.text = objFirstData.city
            self.txtState.text = objFirstData.state
            self.txtCountry.text = objFirstData.country
            
            if objFirstData.addressType ==  "Home" {
                self.addressType = ADDRESS_TYPE.HOME.rawValue
                self.btnAddressType.isSelected = true
            } else if objFirstData.addressType ==  "Office" {
                self.addressType = ADDRESS_TYPE.OFFICE.rawValue
                self.btnAddressType.otherButtons[0].isSelected = true
            }
            
            self.btnDefault.isSelected = objFirstData.isDefaultAddress
            
            self.btnAdd.setTitle("UPDATE", for: [])
        } else {
            self.txtFullName.text = objUserDetail.userName
            self.txtMobile.text = objUserDetail.contactNo
            
            self.btnAdd.setTitle("ADD", for: [])
        }
    }
    
    //MARK: - HELPER -
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnAddressTypeClick(radioButton : DLRadioButton) {
        if radioButton.accessibilityIdentifier ?? "" ==  "Home" {
            self.addressType = ADDRESS_TYPE.HOME.rawValue
        } else if radioButton.accessibilityIdentifier ?? "" ==  "Office" {
            self.addressType = ADDRESS_TYPE.OFFICE.rawValue
        }
        debugPrint("SELECTED OPTION:- \(self.addressType)")
    }
    
    @IBAction func btnSetDefaultClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnAddClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let phonetrimmedString = self.txtMobile.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressField = self.txtAddress.text ?? ""
        
        if self.txtFullName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Full name is required")
        }
        else if self.txtMobile.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Mobile number is required")
        }
        else if !self.txtMobile.isValidPhone() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Mobile number is invalid")
        }
        else if !Validator.minLength(10).apply(phonetrimmedString) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Mobile number should be 10 character long")
        }
        else if self.txtAddress.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Address is required")
        }
        else if addressField.containsSpecialCharacter == true {
            GlobalData.shared.showDarkStyleToastMesage(message: "Address is invalid(Only desk allowed)")
        }
//        else if self.txtPincode.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Pincode is required")
//        }
//        else if self.txtCity.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Town/City is required")
//        }
//        else if self.txtState.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "State is required")
//        }
//        else if self.txtCountry.isEmpty() == 1 {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Country is required")
//        }
//        else if self.addressType == "" {
//            GlobalData.shared.showDarkStyleToastMesage(message: "Address type is required")
//        }
        else {
//            self.btnAdd.isUserInteractionEnabled = false
//            self.callAddUpdateAddressAPI()

            addaddress()
        }
    }

    @IBAction func onSelectShopAddress(_ sender: UIButton) {

    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension MyAddressVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if txtAddress == textField{
            let config = GMSAutocompleteViewController()
            config.delegate = self
            present(config, animated: true, completion: nil)
            self.view.endEditing(true)
        }

    }
}

//MARK: - API CALL -

extension MyAddressVC {
    //ADD/UPDATE ADDRESS
    func callAddUpdateAddressAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var strURL = ""
        
        if self.btnAdd.titleLabel?.text == "ADD" {
            strURL = Constants.URLS.ADD_UPDATE_ADDRESS
        } else {
            let objFirstData = self.arrAddress[0]
            strURL = Constants.URLS.ADD_UPDATE_ADDRESS + "/" + "\(objFirstData._id)"
        }
        
        var params: [String:Any] = [:]
        params["userName"] = self.txtFullName.text ?? ""
        params["userContact"] = self.txtMobile.text ?? ""
        params["userAddresssLine1"] = self.txtAddress.text ?? ""
        params["userPincode"] = self.txtPincode.text ?? ""
        params["city"] = self.txtCity.text ?? ""
        params["state"] = self.txtState.text ?? ""
        params["country"] = self.txtCountry.text ?? ""
        params["addressType"] = self.addressType
        params["isDefaultAddress"] = self.btnDefault.isSelected
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        strongSelf.btnAdd.isUserInteractionEnabled = true
                        NotificationCenter.default.post(name: Notification.Name(kUpdateAddressList), object: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnAdd.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnAdd.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnAdd.isUserInteractionEnabled = true
        }
    }
}


//MARK: - API CALL -

extension MyAddressVC {
    func addaddress() {

        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
//        {
//            "userId":"6337ff976f881ea71b99ff5f",
//            "lat":"22.455544",
//            "long":"77.8686886",
//            "title":"helllo avbcgc"
//        }
        var params: [String:Any] = [:]
        params["lat"] = lat
        params["long"] = lng
        params["title"] = self.txtAddress.text ?? ""
        params["userId"] = objUserDetail._id
        params["fullName"] = self.txtFullName.text ?? ""
        params["mobile"] = self.txtMobile.text ?? ""
        params["addressType"] = addressType

       // fullName, addressType,mobile
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_ADDRESS_New, parameters: params) { responceget in
            print(responceget)

            //            let strongSelf = self
            GlobalData.shared.hideProgress()
            switch responceget {
            case .success(let response):

                GlobalData.shared.showDarkStyleToastMesage(message: "Address added successfully")

                self.navigationController?.popViewController(animated: true)


            case .failed(let errorMessage):

                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }
    }
}
extension MyAddressVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        lat = place.coordinate.latitude
        lng = place.coordinate.longitude
        self.txtAddress.text = place.name ?? ""
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
