//
//  MyAccountVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 09/06/21.
//

import UIKit
import SideMenuSwift
import SDWebImage
import SwiftyJSON
import Photos
import MobileCoreServices


class MyAccountVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewAccInfo: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgBackgroundImage: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var viewVehicleInfo: UIView!
    @IBOutlet weak var viewMyOrderBG: UIView!
    
    @IBOutlet weak var viewMyWalletBG: UIView!
    @IBOutlet weak var lblWalletAmount: UILabel!
    
    @IBOutlet weak var viewMyAddressBG: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var viewNotiPref: UIView!
    @IBOutlet weak var viewAccountSetting: UIView!
    
    var arrAddress: [AddressObject] = []
    
    enum imageSelectMode {
        case BGImage
        case ProfileImage
    }
    
    var chooseImage : imageSelectMode = .BGImage
    
    var bgSelectphoto: Document?
    var profileSelectphoto: Document?

    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        userDetailsSet()
//        getProfileDetails()
    }
    
    func userDetailsSet() {
        
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.imgProfile.sd_setImage(with: URL(string: objUserDetail.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"))
        self.imgBackgroundImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.imgBackgroundImage.sd_setImage(with: URL(string: objUserDetail.profileBGImage), placeholderImage: UIImage.init(named: "bgProfile"))

        self.lblName.text = objUserDetail.firstName + " " + objUserDetail.lastName
        self.lblPhone.text = "\(objUserDetail.countryCode) \(objUserDetail.mobileNumber)"
        self.lblEmail.text = objUserDetail.email
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        //self.viewAccInfo.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        
        DispatchQueue.main.async {
            
            self.viewProfile.layer.cornerRadius = self.viewProfile.layer.frame.size.width / 2
            
            self.viewVehicleInfo.createButtonShadow()
            self.viewMyOrderBG.createButtonShadow()
            self.viewMyWalletBG.createButtonShadow()
            self.viewMyAddressBG.createButtonShadow()
            
        }
        
        if objUserDetail.userType == "rider" {
            self.viewVehicleInfo.isHidden = false
        } else {
            self.viewVehicleInfo.isHidden = true
        }
        
        self.viewNotiPref.isHidden = true
        self.viewAccountSetting.isHidden = true
        
//        self.callGetWalletBalance()
//        self.callGetAddressAPI()
        self.getProfileDetails()
        //self.get_Rider_Vehile_Details()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAddressList), name: NSNotification.Name(rawValue: kUpdateAddressList), object: nil)
    }
    
    //MARK: - HELPER -
    
    @objc func updateAddressList() {
        self.callGetAddressAPI()
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        appDelegate.drawerController.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func btnCartClick(_ sender: UIButton) {
        let controller = GlobalData.cartStoryBoard().instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            chooseImage = .BGImage
            self.showMediaPickerOptions()
        case 2:
            chooseImage = .ProfileImage
            self.showMediaPickerOptions()
        case 3:
            let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            print("")
        }
        
    }
    
    @IBAction func btnChangeVehicleInfo(_ sender: UIButton) {
        let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "EditVehicleInfoVC") as! EditVehicleInfoVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnAllOrderClick(_ sender: UIButton) {
        if objUserDetail.userType == "user" {
            let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            controller.isFromAccount = true
            self.navigationController?.pushViewController(controller, animated: true)
        } else if objUserDetail.userType == "vendor" {
            let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopOwnerOrderListVC") as! ShopOwnerOrderListVC
            controller.isFromAccount = true
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderOrderHistoryVC") as! RiderOrderHistoryVC
            controller.isFromAccount = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func btnWalletDetailClick(_ sender: UIButton) {
        debugPrint("Wallet Detail Click")
    }
    
    @IBAction func btnAddressDetailClick(_ sender: UIButton) {
        
        
        let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyAddressVC") as! MyAddressVC
        controller.arrAddress = self.arrAddress
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnNotificationPrefClick(_ sender: UIButton) {
        debugPrint("Notification Preference Click")
    }
    
    @IBAction func btnAccountSettingClick(_ sender: UIButton) {
        debugPrint("Account Setting Click")
    }

    @IBAction func btnAccountShareClick(_ sender: UIButton) {
        debugPrint("Account Share Click")
        shareProifle()
    }
    
    @IBAction func btnLogoutClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction) in
            appDelegate.logoutUser()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectTypeClick(_ sender: UIButton) {
        print(sender.tag)
        switch sender.tag {
        case 1:
            let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            if objUserDetail.userType == "user" {
                let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
                controller.isFromAccount = true
                self.navigationController?.pushViewController(controller, animated: true)
            } else if objUserDetail.userType == "vendor" {
                let controller = GlobalData.shopOwnerStoryBoard().instantiateViewController(withIdentifier: "ShopOwnerOrderListVC") as! ShopOwnerOrderListVC
                controller.isFromAccount = true
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = GlobalData.riderStoryBoard().instantiateViewController(withIdentifier: "RiderOrderHistoryVC") as! RiderOrderHistoryVC
                controller.isFromAccount = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        case 3:
            gotoRiderDetailsFill()
        case 4:
            
            // TEMP
            let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MySaveAddress") as! MySaveAddress
            self.navigationController?.pushViewController(controller, animated: true)
            
//            let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "MyAddressVC") as! MyAddressVC
//            controller.arrAddress = self.arrAddress
//            self.navigationController?.pushViewController(controller, animated: true)
        case 5:
            let controller = GlobalData.sideMenuStoryBoard().instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(controller, animated: true)
            
            
        default:
            print("coming soon")
        }
    }


    func gotoRiderDetailsFill(type : Int? = 0) {
        if defaults.object(forKey: kAuthToken) != nil {
            if (objUserDetail.isRider) {
                let controller = RiderHomeViewController.getObject()
                self.push(controller: controller)
                //                let controller = VehicleCategoryViewController.getObject()
                //                controller.modalPresentationStyle = .overCurrentContext
                //                controller.modalTransitionStyle = .crossDissolve
                //                controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
                //                    if objUserDetail.isRiderVerified == true{
                //                        self!.gotoRiderCurrentOrder()
                //                    } else {
                //                        self!.showAlert(message: "Your rider profile is not verified yet") { (action) in
                //                            let controller = RiderHomeViewController.getObject()
                //                            self!.push(controller: controller)
                //                        }
                //                    }
                //                }
                //                self.present(controller, animated: true)

            } else {
                //                let controller = VehicleInformationVC.getObject()
                //                self.push(controller: controller)

                let controller = VehicleCategoryViewController.getObject()
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                controller.buttonSubmitCallBack = { [weak self] (vehicleType) in
                    //                    let controller = RiderHomeViewController.getObject()
                    //                    self!.push(controller: controller)
                    let controller = VehicleInformationVC.getObject()
                    self!.push(controller: controller)
                }
                self.present(controller, animated: true)
            }
        } else {
            let controller = LoginVC.getObject()
            controller.loginType = type ?? 0
            let navController = UINavigationController.init(rootViewController: controller)
            appDelegate.drawerController.contentViewController = navController
        }
    }

    func shareProifle(){

        let objectsToShare: [Any] = [lblName.text ?? ""]

            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
    }
}


//MARK: - SHOW MEDIA PICKER OPTIONS -

extension MyAccountVC {
    
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
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.imgProfile.frame.origin.y - 60, width: 0, height: 0) //sender.bounds
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

extension MyAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //        let image = info[.originalImage] as! UIImage
        let image = info[.editedImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!
        self.imgProfile.image = image
        self.imgProfile.contentMode = .scaleAspectFill
        
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
        
        let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_profileImage.jpg"
        let document = Document(
            uploadParameterKey: "profileImage",
            data: data,
            name: name ?? filename,
            fileName: filename,
            mimeType: "image/jpeg"
        )

        if chooseImage == .ProfileImage {
            self.profileSelectphoto = document
            callUpdateProfileAPI()

        }else if chooseImage == .BGImage {
            self.bgSelectphoto = document
            callUpdateUserBGImage()
        }
        
        picker.dismiss(animated: true, completion: nil)
        

    }
}

//MARK: - API CALL -

extension MyAccountVC {
    
    // GET PROFILE DETAILS
    private func getProfileDetails(){
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_PROFILE_DETAILS, parameters: [:]) { responceget in
            print(responceget)
            
            let strongSelf = self
            GlobalData.shared.hideProgress()
            
            
            switch responceget {
            case .success(let response):
                
                if let getData = response["data"] as? NSDictionary {
                    let userDetail = response["data"] as! Dictionary<String, Any>
                    let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                    
                    if let data = try? JSONEncoder().encode(object) {
                        defaults.set(data, forKey: kLoggedInUserData)
                        defaults.synchronize()
                        objUserDetail = object
                        self.userDetailsSet()
                    }
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
    
    private func get_Rider_Vehile_Details(){
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GET_RIDER_VEHCLE_DETAILS, parameters: [:]) { responceget in
            print(responceget)
            
            let strongSelf = self
            GlobalData.shared.hideProgress()
            
            switch responceget {
            case .success(let response):
                
                if let getData = response["data"] as? NSDictionary {
                    
                    print(getData)
                    
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
    
    //GET WALLET BALANCE
    func callGetWalletBalance() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let params: [String:Any] = [:]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.WALLET_BALANCE, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let objWalletDetail = WalletObject.init(payload)
                            strongSelf.lblWalletAmount.text = "$\(objWalletDetail.wallet)"
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //GET ADDRESS
    func callGetAddressAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let params: [String:Any] = [:]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.GET_ADDRESS, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            strongSelf.arrAddress.removeAll()
                            for i in 0..<payloadData.count {
                                let objAddress = AddressObject.init(payloadData[i])
                                strongSelf.arrAddress.append(objAddress)
                            }
                            
                            if strongSelf.arrAddress.count > 0 {
                                let objFirstData = strongSelf.arrAddress[0]
                                
                                strongSelf.lblAddress.text = objFirstData.userAddresssLine1 + ", " + objFirstData.city + ", " + objFirstData.state + ", " + objFirstData.country
                            }
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    
    //UPDATE PROFILE API
    func callUpdateProfileAPI() {
        
        var parm = NSDictionary()
        var sendFiles = [SSFiles]()

        if let photo = profileSelectphoto?.data {
            let vDocument : SSFiles = SSFiles(image: UIImage(data: photo)!, paramKey: "profilePicture")
            sendFiles = [vDocument]
        }else{
            return
        }
        
        var params: [String:Any] = [:]
        params = ["fullName" : objUserDetail.userName]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.UPDATE_USER_PROFILE, files: sendFiles, parameters: params) { responce in
            print(responce)
            
            GlobalData.shared.hideProgress()
            
            switch responce {
            case .success(let jsondata):
                
                GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))

                self.getProfileDetails()
                
//                let userDetail = jsondata["data"] as! Dictionary<String, Any>
//                let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
//
//                if let data = try? JSONEncoder().encode(object) {
//
////                    defaults.set(data, forKey: kLoggedInUserData)
////                    defaults.synchronize()
////                    objUserDetail = object
////                    self.userDetailsSet()
//
//                    self.getProfileDetails()
//                }
                
            case .failed(let errorMessage):
                
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }
    }
    
    
  
    //UPDATE PROFILE API
    func callUpdateUserBGImage() {
        
        var parm = NSDictionary()
        var sendFiles = [SSFiles]()
        
        if let photo = bgSelectphoto?.data {
            let vDocument : SSFiles = SSFiles(image: UIImage(data: photo)!, paramKey: "backgroundPicture")
            sendFiles = [vDocument]
        }else{
            return
        }
        
        let params: [String:Any] = [:]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.UPDATE_USER_BGIMAGE, files: sendFiles, parameters: params) { responce in
            print(responce)
            
            GlobalData.shared.hideProgress()
            
            switch responce {
            case .success(let jsondata):
                
                GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))
                
                let userDetail = jsondata["data"] as! Dictionary<String, Any>
                let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                
                if let data = try? JSONEncoder().encode(object) {
                    
//                    defaults.set(data, forKey: kLoggedInUserData)
//                    defaults.synchronize()
//                    objUserDetail = object
//                    self.userDetailsSet()
                    
                    self.getProfileDetails()
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

