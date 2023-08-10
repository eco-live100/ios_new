//
//  VehicleInformationVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 07/06/21.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import DropDown
import Photos
import MobileCoreServices
import CometChatPro

class VehicleInformationVC: UIViewController {
    
    static func getObject()-> VehicleInformationVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VehicleInformationVC") as? VehicleInformationVC
        if let vc = vc {
            return vc
        }
        return VehicleInformationVC()
    }

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var viewVechilName: UIView!
    @IBOutlet weak var viewVechilNumber: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var viewUploadFile: CustomDashedView!
    @IBOutlet weak var viewUploadLicense: CustomDashedView!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var imgDocumentLicense: UIImageView!
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var txtVehicleType: UITextField!
    @IBOutlet weak var txtVehicleName: UITextField!
    @IBOutlet weak var txtVehicleNumber: UITextField!
    
    @IBOutlet weak var imageHeader: UIImageView!

    
    var strSelectedVehicleType: String = ""{
        didSet{
            if strSelectedVehicleType == "Motorcycle" {
                imageHeader.image = UIImage(named: "Delivery-amico")
            } else {
                imageHeader.image = UIImage(named: "online-taxi")
            }
        }
    }
    
    var categoryDropDown = DropDown()
    var typeDropDown = DropDown()
    
    var photoDocument: Document?
    var photoDocumentLicense: Document?

    var strName = ""
    var strEmail = ""
    var strPassword = ""
    var strCountryCode = ""
    var strPhoneNo = ""
    
//    var arrVehicleCategory: [VehicleCategoryObject] = []
    var selectedVehicleCategory = ""
    var selectedVehicleType = ""

    var arrVehicleCategory: [ProductCategoryObjectNew] = []
    var arrVehicleType: [ProductTypeObjectNew] = []
    
    var imageSelectType = 0
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDetail()
        self.apiVehicleCatlist()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageDocumentClick(_:)))
        self.imgDocument.addGestureRecognizer(objGesture)
        self.imgDocument.isUserInteractionEnabled = true
        self.imgDocument.contentMode = .scaleAspectFit
        self.imgDocument.image = UIImage.init(named: "ic_placeholder")
        
        let objGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageDocumentLicenseClick(_:)))
        self.imgDocumentLicense.addGestureRecognizer(objGesture2)
        self.imgDocumentLicense.isUserInteractionEnabled = true
        self.imgDocumentLicense.contentMode = .scaleAspectFit
        self.imgDocumentLicense.image = UIImage.init(named: "ic_placeholder")
        
        DispatchQueue.main.async {
            self.viewCategory.layer.cornerRadius = self.viewCategory.frame.height / 2.0
            self.viewCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewCategory.layer.borderWidth = 1.0
            
            self.viewType.layer.cornerRadius = self.viewCategory.frame.height / 2.0
            self.viewType.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewType.layer.borderWidth = 1.0
            
            self.viewVechilName.layer.cornerRadius = self.viewCategory.frame.height / 2.0
            self.viewVechilName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewVechilName.layer.borderWidth = 1.0
            
            self.viewVechilNumber.layer.cornerRadius = self.viewCategory.frame.height / 2.0
            self.viewVechilNumber.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewVechilNumber.layer.borderWidth = 1.0
            
            self.btnSignup.layer.cornerRadius = self.btnSignup.frame.height / 2.0
            self.btnSignup.createButtonShadow()
        }
        
        //FETCH VEHICLE CATEGORY DATA
        if let data = defaults.value(forKey: configurationData) as? Data,
            let configData = try? JSONDecoder().decode(UtilityObject.self, from: data) {
            GlobalData.shared.objConfiguration = configData
//            self.arrVehicleCategory = GlobalData.shared.objConfiguration.arrVehicleCategory
        }
        
        
    }
    
    //MARK: - HELPER -
    
    func setupCategoryDropDown() {
        
        self.categoryDropDown = DropDown()
        
//        let arrCategory = self.arrVehicleCategory.map { $0.name }
 
        var CategorydataSource: [String] = []
        for item in arrVehicleCategory{
            CategorydataSource.append("\( item.name) $ \(item.vehicleTypeColor)")
        }
    
        self.categoryDropDown.backgroundColor = .white
        self.categoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.categoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.categoryDropDown.selectedTextColor = .white
        
        self.categoryDropDown.anchorView = self.viewCategory
        self.categoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.categoryDropDown.anchorView?.plainView.bounds.height)! + 25))
        self.categoryDropDown.dataSource = CategorydataSource
        self.categoryDropDown.direction = .bottom
        self.categoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.categoryDropDown.cellHeight = 42
        
//        guard let index = arrCategory.firstIndex(of: self.txtCategory.text ?? "Pedestrian") else { return }
//        self.categoryDropDown.selectRow(index, scrollPosition: .top)
        
        self.categoryDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            if item.contains("$") {
                let strArray = item.split(separator: "$")
                self.txtCategory.text = String(strArray[0])
            }
            self.selectedVehicleCategory = self.arrVehicleCategory[index]._id
        }
        
        self.typeDropDown = DropDown()
        
        let arrTypes = self.arrVehicleType.map { $0.name }
        
        self.typeDropDown.backgroundColor = .white
        self.typeDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.typeDropDown.textColor = Constants.Color.THEME_BLACK
        self.typeDropDown.selectedTextColor = .white
        
        self.typeDropDown.anchorView = self.viewType
        self.typeDropDown.bottomOffset = CGPoint(x: 0, y:((self.typeDropDown.anchorView?.plainView.bounds.height)! + 25))
        self.typeDropDown.dataSource = arrTypes
        self.typeDropDown.direction = .bottom
        self.typeDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.typeDropDown.cellHeight = 42
        
        self.typeDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            self.txtVehicleType.text = item
            self.strSelectedVehicleType = item
            self.selectedVehicleType = self.arrVehicleType[index]._id
        }
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
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVehicleCategoryClick(_ sender: UIButton) {
        if sender.tag == 0 {
            self.categoryDropDown.show()
            
        }else {
            self.typeDropDown.show()
        }
    }
    
    @IBAction func btnSignupClick(_ sender: UIButton) {
        apicallwithvalidation(type: "addvehicle")
    }
    
    @IBAction func actionAddOtherVehicleClick(_ sender: UIButton) {
        apicallwithvalidation(type: "addothervehicle")
    }
    
    func apicallwithvalidation(type:String)  {
        if self.txtCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Category is required")
        }else if self.txtVehicleType.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Type is required")
        }else if self.txtVehicleName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Vehicle Name is required")
        } else if self.txtVehicleNumber.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Vehicle Number is required")
        }else if self.imgDocument.image == nil || self.imgDocument.image == UIImage.init(named: "ic_placeholder") {
            GlobalData.shared.showDarkStyleToastMesage(message: "Vehicle’s appropriate documents is required")
        } else if self.imgDocumentLicense.image == nil || self.imgDocumentLicense.image == UIImage.init(named: "ic_placeholder") {
            GlobalData.shared.showDarkStyleToastMesage(message: "License’s appropriate documents is required")
        } else {
            self.btnSignup.isUserInteractionEnabled = false
            let parm = ["vehicleCategoryId" : selectedVehicleCategory,
                        "vehicleTypeId" : selectedVehicleType,
                        "vehicleName" : ((txtVehicleName.text ?? "")),
                        "vehicleNumber" : ((txtVehicleNumber.text ?? "")),
            ] as! [String : Any]
            
            apiVehicleVehicledetails(parm: parm,type: type)
        }
    }
    
    func resetAllDatainForm()  {
        self.txtCategory.text = ""
        self.txtVehicleType.text = ""
        self.txtVehicleName.text = ""
        self.txtVehicleNumber.text = ""
        self.imgDocument.image = UIImage.init(named: "ic_placeholder")
        self.imgDocumentLicense.image = UIImage.init(named: "ic_placeholder")
    }
    
    func pushHomeController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.homeStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
}

//MARK: - SHOW MEDIA PICKER OPTIONS -

extension VehicleInformationVC {
    
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
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.imgDocument.frame.origin.y - 60, width: 0, height: 0) //sender.bounds
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

extension VehicleInformationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        let image = info[.originalImage] as! UIImage
        let image = info[.editedImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!

        if imageSelectType == 0 {
            self.imgDocument.image = image
            self.imgDocument.contentMode = .scaleAspectFill
        }else{
            self.imgDocumentLicense.image = image
            self.imgDocumentLicense.contentMode = .scaleAspectFill
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
            self.photoDocument = document
        }else{
            self.photoDocumentLicense = document
        }
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API CALL -

extension VehicleInformationVC {
    
    func apiVehicleCatlist(){
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.VEHICLECATEGORIESLIST, parameters: [:]) { responce in
            print(responce)
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                print(jsondata)
                if let payloadData = jsondata["data"] as? NSDictionary {
                    
                    if let vehicleCategory = payloadData["vehicleType"] as? NSArray {
                        
                        for i in 0..<vehicleCategory.count  {
                            let objData = ProductCategoryObjectNew.init(vehicleCategory[i] as! [String : Any])
                            self.arrVehicleCategory.append(objData)
                        }
                    }
                    if let vehicleType = payloadData["vehicleCategory"] as? NSArray {
                        for i in 0..<vehicleType.count  {
                            let objData = ProductTypeObjectNew.init(vehicleType[i] as! [String : Any])
                            self.arrVehicleType.append(objData)
                        }
                    }
                    
                    self.setupCategoryDropDown()
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
    
    func apiVehicleVehicledetails(parm : [String : Any],type: String){
        let vDocument : SSFiles = SSFiles(image: UIImage(data: photoDocument!.data)!, paramKey: "vehicleDocument")
        let vLicense : SSFiles = SSFiles(image: UIImage(data: photoDocumentLicense!.data)!, paramKey: "driverLicense")
        
        let sendFiles = [vDocument,vLicense]
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.RIDER_VEHICLE_DETAILS_SUBMIT, files: sendFiles, parameters: parm) { responce in
            print(responce)
            
            GlobalData.shared.hideProgress()
            self.btnSignup.isUserInteractionEnabled = true
            
            switch responce {
            case .success(let jsondata):
                GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))
                if let payloadData = jsondata["data"] as? NSDictionary {
                    objUserDetail.userType = "driver"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        if type == "addothervehicle"{
                            self.resetAllDatainForm()
                        }else if type == "addvehicle" {
                            self.pushRiderHomeController()
                        }
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
    
    func pushRiderHomeController() {
        let leftMenuVC = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderHomeViewController") as! RiderHomeViewController
        let navController = UINavigationController.init(rootViewController: controller)
        appDelegate.drawerController.contentViewController = navController
        appDelegate.drawerController.menuViewController = leftMenuVC
        appDelegate.window?.rootViewController = appDelegate.drawerController
    }
}

//extension VehicleInformationVC {
    
//    func callRiderSignupAPI() {
//        if GlobalData.shared.checkInternet() == false {
//            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
//            return
//        }
//
//        var deviceToken: String = "123456"
//        if defaults.value(forKey: "deviceToken") != nil {
//            deviceToken = defaults.value(forKey: "deviceToken") as! String
//        }
//
//        var params: [String:Any] = [:]
//        params["userName"] = self.strName
//        params["email"] = self.strEmail
//        params["password"] = self.strPassword
//        params["countryCode"] = self.strCountryCode
//        params["contactNo"] = self.strPhoneNo
//        params["vehicalName"] = self.txtCategory.text ?? ""
//        params["vehicalCategory"] = self.selectedVehicleCategory
//        params["userType"] = "rider"
//        params["loginType"] = "normal"
//        params["deviceType"] = kDeviceType
//        params["deviceToken"] = deviceToken
//
//        var selectedDocs: [Document] = []
//        if let selectedDoc = self.photoDocument {
//            selectedDocs = [selectedDoc]
//        }
//
//        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
//
//        AFWrapper.shared.postWithUploadMultipleFiles(selectedDocs, strURL: Constants.URLS.SIGNUP, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
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
//    }
//}
