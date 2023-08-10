//
//  SoleProprietorsRegistrationVC.swift
//  EcoLive
//
//  Created by Emizen Tech Amit on 24/06/22.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import DropDown
import CountryPickerView
import CometChatPro
import Photos
import MobileCoreServices
import GoogleMaps
import GooglePlaces
import GoogleMapsCore
 

class SoleProprietorsRegistrationVC: UIViewController, UITextViewDelegate {
    
    static func getObject()-> SoleProprietorsRegistrationVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SoleProprietorsRegistrationVC") as? SoleProprietorsRegistrationVC
        if let vc = vc {
            return vc
        }
        return SoleProprietorsRegistrationVC()
    }
    
    //MARK: - PROPERTIES & OUTLETS
    @IBOutlet weak var viewHeaderNavigation :UIView!
    @IBOutlet weak var txtShopName: UITextField!
    @IBOutlet weak var txtShopAddress: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var viewShopCategory: UIView!
    @IBOutlet weak var txtShopCategory: UITextField!
    @IBOutlet weak var viewShopType: UIView!
    @IBOutlet weak var txtShopType: UITextField!
    @IBOutlet weak var txtNumberOfLocation: UITextField!
    @IBOutlet weak var viewNumberOfLocation: UIView!
    
    @IBOutlet weak var viewUploadPhotoID: CustomDashedView!
    @IBOutlet weak var viewUploadShopLicense: CustomDashedView!
    @IBOutlet weak var viewUploadShopLogo: CustomDashedView!
    @IBOutlet weak var textviewDescription : UITextView!
    @IBOutlet weak var imgPhotoID: UIImageView!
    @IBOutlet weak var imgShopLicense: UIImageView!
    @IBOutlet weak var imgShopLogo: UIImageView!
    @IBOutlet weak var countryPicker: CountryPickerView!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    
    
    var strShopName : String = ""{
        didSet{
            txtShopName.text = strShopName
        }
    }
    
    var strShopAddress : String = ""{
        didSet{
            txtShopAddress.text = strShopAddress
        }
    }

    var strShoplat : String = ""
    var strShoLong : String = ""

    var strFirstName : String = ""{
        didSet{
            txtFirstName.text = strFirstName
        }
    }
    
    var strLastName: String = ""{
        didSet{
            txtLastName.text = strLastName
        }
    }
    
    var strEmail: String = ""{
        didSet{
            txtEmail.text = strEmail
        }
    }
    
    var strMobileNumber : String = ""{
        didSet{
            txtMobileNumber.text = strMobileNumber
        }
    }
    
    var strNumberofLocation : String = "" {
        didSet{
            txtNumberOfLocation.text = strNumberofLocation
        }
    }
    
    var strDescription : String = "" {
        didSet{
            textviewDescription.text = strDescription
        }
    }
    
    var isSelectNotification : Bool = false {
        didSet{
            if isSelectNotification {
                buttonNotification.setImage(UIImage(named: "Check box"), for: .normal)
            } else {
                buttonNotification.setImage(UIImage(named: "Uncheck box"), for: .normal)
            }
        }
    }
   
    //MARK: - LOCAL VARIABLE
    var selectedShopCategory = ""
    var selectedShopType = ""
    var imageSelectType = 0
    var arrShopCategory: [ShopInfoCategoryObject] = []
    var shopCategoryDropDown = DropDown()
    var shopTypeDropDown     = DropDown()
    var shopNumberofLocation = DropDown()
    var photoDocumentID: Document?
    var photoDocumentShopLicense: Document?
    var photoShopLogo: Document?
    var strCountryCode = ""
    var typeofRegistration : String = ""
    //MARK: - VIEWCONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeaderNavigation.roundCorners(corners: [.bottomLeft , .bottomRight ], radius: 15.0)
        self.apiShopCatlist()
        self.setupNumberofLocation()
        self.setupViewDetail()
        
        textviewDescription.text = "Description"
        textviewDescription.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
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
        
        
        let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageDocumentClick(_:)))
        self.imgPhotoID.addGestureRecognizer(objGesture)
        self.imgPhotoID.isUserInteractionEnabled = true
        self.imgPhotoID.contentMode = .scaleAspectFit
        self.imgPhotoID.image = UIImage.init(named: "ic_placeholder")
        
        let objGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageDocumentLicenseClick(_:)))
        self.imgShopLicense.addGestureRecognizer(objGesture2)
        self.imgShopLicense.isUserInteractionEnabled = true
        self.imgShopLicense.contentMode = .scaleAspectFit
        self.imgShopLicense.image = UIImage.init(named: "ic_placeholder")
        
        let objGesture3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageShopLogoClick(_:)))
        self.imgShopLogo.addGestureRecognizer(objGesture3)
        self.imgShopLogo.isUserInteractionEnabled = true
        self.imgShopLogo.contentMode = .scaleAspectFit
        self.imgShopLogo.image = UIImage.init(named: "ic_placeholder")
    }
    
    @objc func imageDocumentClick(_ sender:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        imageSelectType = 0
        self.showMediaPickerOptions()
        
    }
    @objc func imageDocumentLicenseClick(_ sender:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        imageSelectType = 1
        self.showMediaPickerOptions()
    }
    @objc func imageShopLogoClick(_ sender:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        imageSelectType = 2
        self.showMediaPickerOptions()
    }
    
    //MARK: - ACTIONS
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionNotificationClick(_ sender: UIButton) {
        isSelectNotification = !isSelectNotification
    }
    
    @IBAction func actionSubmitClick(_ sender: UIButton) {
        
        let phonetrimmedString = self.txtMobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtShopName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop name is required")
        } else if self.txtShopAddress.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop address is required")
        } else if self.txtFirstName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "First name is required")
        } else if self.txtLastName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Last name is required")
        } else if self.txtEmail.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
        } else if !self.txtEmail.isValidEmail() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
        } else if self.strCountryCode == "" {
            GlobalData.shared.showDarkStyleToastMesage(message: "Country code is required")
        } else if self.txtMobileNumber.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is required")
        } else if !self.txtMobileNumber.isValidPhone() {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number is invalid")
        } else if !Validator.minLength(10).apply(phonetrimmedString) {
            GlobalData.shared.showDarkStyleToastMesage(message: "Phone number should be 10 character long")
        }  else if self.txtNumberOfLocation.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Number of location is required")
        } else if self.txtShopType.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop type is required")
        } else if self.txtShopCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop category is required")
        } else if self.imgPhotoID.image == nil || self.imgPhotoID.image == UIImage.init(named: "ic_placeholder") {
            GlobalData.shared.showDarkStyleToastMesage(message: "Documents is required")
        } else if self.imgShopLicense.image == nil || self.imgShopLicense.image == UIImage.init(named: "ic_placeholder") {
            GlobalData.shared.showDarkStyleToastMesage(message: "Documents is required")
        } else if isSelectNotification == false{
            self.showAlert(message: "Please check the 'I agree WhatsApp Messaging'")
        }else {
            self.buttonSubmit.isUserInteractionEnabled = false
            
            let parm = ["storeType" : typeofRegistration,
                        "shopName" :  strShopName,
                        "firstName" : strFirstName,
                        "lastName" : strLastName ,
                        "email" : strEmail ,
                        "countryCode" : strCountryCode,
                        "mobileNumber" : strMobileNumber,
                        "numberOfLocation" : strNumberofLocation,
                        "shopCategoryId" : selectedShopType,
                        "shopSubCategoryId" : selectedShopCategory,
                        "latitude": strShoplat,
                        "longitude":strShoLong,
                        "shopDescription" : strDescription,
                        "storeAddress" : strShopAddress
            ] as! [String : Any]
            
            apiSoleProprietorsdetails(parm: parm)
        }
    }
    
    @IBAction func btnShopTypeClick(_ sender: UIButton) {
        self.shopCategoryDropDown.show()
    }
    
    @IBAction func btnShopCetegogoryClick(_ sender: UIButton) {
        self.shopTypeDropDown.show()
    }
    
    @IBAction func btnSelectCountryClick(_ sender: UIButton) {
        self.countryPicker.showCountriesList(from: self)
    }
    
    @IBAction func btnNumberofLocationClick(_ sender: UIButton) {
        self.shopNumberofLocation.show()
    }
    @IBAction func onChangeTxtShopName(_ sender: UITextField) {
        strShopName = sender.text ?? ""
    }
    
    @IBAction func onSelectShopAddress(_ sender: UIButton) {
        let config = GMSAutocompleteViewController()
        config.delegate = self
        present(config, animated: true, completion: nil)
    }
    
    @IBAction func onChangeFirstName(_ sender: UITextField) {
        strFirstName = sender.text ?? ""
    }
    
    @IBAction func onChangeLastName(_ sender: UITextField) {
        strLastName = sender.text ?? ""
    }
    
    @IBAction func onChangeEmail(_ sender: UITextField) {
        strEmail = sender.text ?? ""
    }
    
    @IBAction func onChangeMobileNumber(_ sender: UITextField) {
        strMobileNumber = sender.text ?? ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textviewDescription.textColor == UIColor.lightGray {
            
            strDescription = ""
            textviewDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textviewDescription.text.isEmpty {
            strDescription = "Description"
            textviewDescription.textColor = UIColor.lightGray
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
     
    //MARK: - HELPER -
    
    func setupShopCategoryDropDown() {
        
        self.shopCategoryDropDown = DropDown()

        let arrCategory = self.arrShopCategory.map { $0.name }
                
        self.shopCategoryDropDown.backgroundColor = .white
        self.shopCategoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.shopCategoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.shopCategoryDropDown.selectedTextColor = .white
        
        self.shopCategoryDropDown.anchorView = self.viewShopType
        self.shopCategoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.shopCategoryDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.shopCategoryDropDown.dataSource = arrCategory
        self.shopCategoryDropDown.direction = .bottom
        self.shopCategoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.shopCategoryDropDown.cellHeight = 42
        
        self.shopCategoryDropDown.selectionAction = { (index: Int, item: String) in
            self.txtShopType.text = item
            self.selectedShopType = self.arrShopCategory[index]._id
            
            self.txtShopCategory.text = ""
            self.selectedShopCategory = ""
            
            self.setupShopSubCategories()
        }
    }
    
    func setupShopSubCategories() {
        
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
    
    func setupNumberofLocation() {
        
        self.shopNumberofLocation = DropDown()
        let shopNumber = ["1","2","3","4","5","6","7","8","9"]
        self.shopNumberofLocation.backgroundColor = .white
        self.shopNumberofLocation.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.shopNumberofLocation.textColor = Constants.Color.THEME_BLACK
        self.shopNumberofLocation.selectedTextColor = .white
        
        self.shopNumberofLocation.anchorView = self.viewNumberOfLocation
        self.shopNumberofLocation.bottomOffset = CGPoint(x: 0, y:((self.shopNumberofLocation.anchorView?.plainView.bounds.height)! + 10))
        self.shopNumberofLocation.dataSource = shopNumber
        self.shopNumberofLocation.direction = .bottom
        self.shopNumberofLocation.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.shopNumberofLocation.cellHeight = 42
        
        self.shopNumberofLocation.selectionAction = { (index: Int, item: String) in
            self.strNumberofLocation = item
        }
        
    }

}

extension SoleProprietorsRegistrationVC {
    
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
    
    func apiSoleProprietorsdetails(parm : [String : Any]){
    
        var sendFiles:[SSFiles] = []
        let vDocument : SSFiles = SSFiles(image: UIImage(data: photoDocumentID!.data)!, paramKey: "storeDocument")
        let vLicense : SSFiles = SSFiles(image: UIImage(data: photoDocumentShopLicense!.data)!, paramKey: "storeDocument")
        if imgShopLogo.image != nil{
            let vLogo : SSFiles = SSFiles(image: UIImage(data: photoShopLogo!.data)!, paramKey: "storeLogo")
            sendFiles = [vDocument,vLicense,vLogo]
        }else{
            sendFiles = [vDocument,vLicense]
        }
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.ADD_VENDOR_SHOP_DETAILS, files: sendFiles, parameters: parm) { responce in

            print(responce)
            
            GlobalData.shared.hideProgress()
            self.buttonSubmit.isUserInteractionEnabled = true
            
            switch responce {
            case .success(let jsondata):
                GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))
                if let payloadData = jsondata["data"] as? NSDictionary {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        print(payloadData)
                        self.pushHomeController()
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
}
//MARK: - SHOW MEDIA PICKER OPTIONS -

extension SoleProprietorsRegistrationVC {
    
    func showMediaPickerOptions() {
        let fromCameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (_) in
            self.pickerAction(sourceType: .camera)
        }
        
        let fromPhotoLibraryAction = UIAlertAction(title: "Choose from Gallery", style: .default) { (_) in
            self.pickerAction(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: "Upload picture", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(fromCameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(fromPhotoLibraryAction)
        }
        alert.addAction(cancelAction)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.view //sender
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.imgPhotoID.frame.origin.y - 60, width: 0, height: 0) //sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerAction(sourceType : UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            picker.allowsEditing = true
            picker.mediaTypes = [kUTTypeImage as String]
            if sourceType == .camera {
                self.cameraAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(picker, animated: true, completion: nil)
                    } else {
                        self.alertForPermissionChange(forFeature: "Camera", library: "Camera", action: "take")
                    }
                })
            }
            if sourceType == .photoLibrary {
                self.photosAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(picker, animated: true, completion: nil)
                    } else {
                        self.alertForPermissionChange(forFeature: "Photos", library: "Photo Library", action: "select")
                    }
                })
            }
        }
    }
    
    func alertForPermissionChange(forFeature feature: String, library: String, action: String) {
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            UIApplication.shared.openSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Please enable camera access from Settings > reiwa.com > Camera to take photos
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "App"
        
        let title = "\"\(appName)\" " + "Would Like to Access the" + " \(library)"
        let message = "Please enable" + " \(library) " + "access from Settings" + " > \(appName) > \(feature) " + "to" + " \(action) " + "photos"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraAccessPermissionCheck(completion: @escaping (Bool) -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAutherisationState = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAutherisationState {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: cameraMediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            break
        }
    }
    
    func photosAccessPermissionCheck(completion: @escaping (Bool)->Void) {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        switch photosStatus {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(true)
                    default:
                        completion(false)
                    }
                }
            })
        @unknown default:
            break
        }
    }
}

//MARK: - UIIMAGEPICKER CONTROLLER DELEGATE -

extension SoleProprietorsRegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[.editedImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!

        if imageSelectType == 0 {
            self.imgPhotoID.image = image
            self.imgPhotoID.contentMode = .scaleAspectFill
        } else if imageSelectType == 1 {
            self.imgShopLicense.image = image
            self.imgShopLicense.contentMode = .scaleAspectFill
        } else {
            self.imgShopLogo.image = image
            self.imgShopLogo.contentMode = .scaleAspectFill
        }
        
        var name: String?
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                name = assetResources.first!.originalFilename
            }
        } else {
            if let imageURL = info[.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                name = assetResources.first?.originalFilename
            }
        }
        
        let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_vehicalImage.jpg"
        let document = Document(
            uploadParameterKey: "vehicalImage",
            data: data,
            name: name ?? filename,
            fileName: filename,
            mimeType: "image/jpeg"
        )
        
        if imageSelectType == 0 {
            self.photoDocumentID = document
        } else if imageSelectType == 1 {
            self.photoDocumentShopLicense = document
        } else {
            self.photoShopLogo = document
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension SoleProprietorsRegistrationVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}


extension SoleProprietorsRegistrationVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        strShopAddress = place.name ?? ""
        strShoplat = String(place.coordinate.latitude ?? 0.0)
        strShoLong = String(place.coordinate.longitude ?? 0.0)
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
