//
//  EditProfileVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 18/08/21.
//

import UIKit
import Photos
import MobileCoreServices
import SDWebImage
import SwiftValidators
import SwiftyJSON
import CountryPickerView

class EditProfileVC: UIViewController {
    
    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var imageIsVerify:UIImageView!
    
    var photoDocument: Document?
    var strCountryCode = ""
    
    
    //MARK: - VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateUI()
    }
    
    func updateUI(){
        
        if objUserDetail.isEmailVerified {
            imageIsVerify.image = UIImage(named: "icon-badge-check")
            txtEmail.alpha = 0.6
            txtEmail.isUserInteractionEnabled = false
        }else{
            imageIsVerify.image = UIImage(named: "icon-badge-uncheck")
        }
        
        self.txtName.text = objUserDetail.firstName + " " + objUserDetail.lastName
        self.txtPhone.text = "\(objUserDetail.countryCode) \(objUserDetail.mobileNumber)"
        self.txtEmail.text = objUserDetail.email
        
                
        txtPhone.alpha = 0.6
        txtPhone.isUserInteractionEnabled = false
        countryPicker.alpha = 0.6
        countryPicker.isUserInteractionEnabled = false
        
        imgProfile.sd_setImage(with: URL(string: objUserDetail.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { (img, err, cacheType, imgURL) in
            //
            if img != nil {
                debugPrint("image is not nil")
            } else {
                debugPrint("image is nil")
            }
            
            guard let data = self.imgProfile.image?.jpegData(compressionQuality: 0.5)! else { return }
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_profileImage.jpg"
            let document = Document(
                uploadParameterKey: "profileImage",
                data: data,
                name: filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.photoDocument = document
        })
    }
    
    //MARK: - SETUP VIEW -
    
    func setupViewDetail() {
        let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageProfileClick(_:)))
        self.imgProfile.addGestureRecognizer(objGesture)
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile.image = UIImage.init(named: "user_placeholder")
        
        self.countryPicker.delegate = self
        self.countryPicker.showCountryCodeInView = false
        self.countryPicker.showPhoneCodeInView = true
        self.countryPicker.showCountryNameInView = false
        self.countryPicker.font = UIFont.init(name: Constants.Font.ROBOTO_REGULAR, size: 16.0)!
        self.countryPicker.textColor = UIColor.init(hex: 0x333333)
        self.countryPicker.flagSpacingInView = 0.0
        
        DispatchQueue.main.async {
            self.viewProfile.layer.cornerRadius = self.viewProfile.layer.frame.size.width / 2
            
            self.viewName.layer.cornerRadius = self.viewName.frame.height / 2.0
            self.viewName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewName.layer.borderWidth = 1.0
            
            self.viewEmail.layer.cornerRadius = self.viewEmail.frame.height / 2.0
            self.viewEmail.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewEmail.layer.borderWidth = 1.0
            
            self.viewPhone.layer.cornerRadius = self.viewPhone.frame.height / 2.0
            self.viewPhone.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewPhone.layer.borderWidth = 1.0
            
            self.btnUpdate.layer.cornerRadius = self.btnUpdate.frame.height / 2.0
            self.btnUpdate.createButtonShadow()
        }
        
        //self.callGetProfileAPI()
    }
    
    //MARK: - HELPER -
    
    @objc func imageProfileClick(_ sender:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        self.showMediaPickerOptions()
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let phonetrimmedString = self.txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.imgProfile.image == nil || self.imgProfile.image == UIImage.init(named: "user_placeholder") {
            GlobalData.shared.showDarkStyleToastMesage(message: "Profile picture is required")
        }
        else if self.txtName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Name is required")
        }
        //        else if self.txtEmail.isEmpty() == 1 {
        //            GlobalData.shared.showDarkStyleToastMesage(message: "Email is required")
        //        }
        //        else if !self.txtEmail.isValidEmail() {
        //            GlobalData.shared.showDarkStyleToastMesage(message: "Email is invalid")
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
        else {
            self.btnUpdate.isUserInteractionEnabled = false
            self.callUpdateProfileAPI()
        }
    }
}

//MARK: - COUNTRY PICKER DELEGATE METHOD -

extension EditProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        debugPrint("Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)")
        self.strCountryCode = country.phoneCode
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension EditProfileVC: UITextFieldDelegate {
    
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

//MARK: - SHOW MEDIA PICKER OPTIONS -

extension EditProfileVC {
    
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

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.photoDocument = document
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API CALL -

extension EditProfileVC {
    //GET PROFILE API
    //    func callGetProfileAPI() {
    //        if GlobalData.shared.checkInternet() == false {
    //            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
    //            return
    //        }
    //
    //        let params: [String:Any] = [:]
    //
    //        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
    //
    //        AFWrapper.shared.requestPOSTURL(Constants.URLS.GET_PROFILE, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
    //            guard let strongSelf = self else { return }
    //
    //            GlobalData.shared.hideProgress()
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
    //                            defaults.synchronize()
    //
    //                            objUserDetail = object
    //
    //                            strongSelf.txtName.text = objUserDetail.userName
    //                            strongSelf.txtEmail.text = objUserDetail.email
    //                            strongSelf.txtPhone.text = objUserDetail.contactNo
    //                            strongSelf.strCountryCode = objUserDetail.countryCode
    //
    //                            //SET COUNTRY BASED ON DIAL CODE
    //                            strongSelf.countryPicker.setCountryByPhoneCode(strongSelf.strCountryCode)
    //
    //                            strongSelf.imgProfile.sd_setImage(with: URL(string: objUserDetail.profileImage), placeholderImage: UIImage.init(named: "user_placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { (img, err, cacheType, imgURL) in
    //
    //                                if img != nil {
    //                                    debugPrint("image is not nil")
    //                                } else {
    //                                    debugPrint("image is nil")
    //                                }
    //
    //                                guard let data = strongSelf.imgProfile.image?.jpegData(compressionQuality: 0.5)! else { return }
    //
    //                                let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_profileImage.jpg"
    //                                let document = Document(
    //                                    uploadParameterKey: "profileImage",
    //                                    data: data,
    //                                    name: filename,
    //                                    fileName: filename,
    //                                    mimeType: "image/jpeg"
    //                                )
    //                                strongSelf.photoDocument = document
    //                            })
    //
    //                            strongSelf.txtEmail.alpha = 0.6
    //                            strongSelf.txtEmail.isUserInteractionEnabled = false
    //                        }
    //                    }
    //                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
    //                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
    //                    }
    //                    else {
    //                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
    //                    }
    //                }
    //            }
    //        }) { (error) in
    //            GlobalData.shared.hideProgress()
    //            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
    //        }
    //    }
    
    //UPDATE PROFILE API
    func callUpdateProfileAPI() {
        
        let vDocument : SSFiles = SSFiles(image: UIImage(data: photoDocument!.data)!, paramKey: "profilePicture")
        let parm = ["fullName" : txtName.text?.trimmingCharacters(in: .whitespaces)]
        
        let sendFiles = [vDocument]
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.UPDATE_USER_PROFILE, files: sendFiles, parameters: parm) { responce in
            print(responce)
            
            GlobalData.shared.hideProgress()
            
            switch responce {
            case .success(let jsondata):
                
                GlobalData.shared.showDarkStyleToastMesage(message: (jsondata["message"] as? String ?? ""))

                self.navigationController?.popViewController(animated: true)

                
//                let userDetail = jsondata["data"] as! Dictionary<String, Any>
//                let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
//                
//                if let data = try? JSONEncoder().encode(object) {
//                    
//                    defaults.set(data, forKey: kLoggedInUserData)
//                    defaults.synchronize()
//                    objUserDetail = object
//                    self.updateUI()
//                    self.navigationController?.popViewController(animated: true)
//                    
//                }
                
                
                
            case .failed(let errorMessage):
                
                switch errorMessage {
                default:
                    self.handleDefaultResponse(errorMessage: errorMessage)
                    break
                }
            }
        }
        
        return
        
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.UPDATE_PROFILE + "/" + "\(objUserDetail._id)"
        
        var params: [String:Any] = [:]
        params["userName"] = self.txtName.text ?? ""
        params["email"] = self.txtEmail.text ?? ""
        params["countryCode"] = self.strCountryCode
        params["contactNo"] = self.txtPhone.text ?? ""
        
        var selectedDocs: [Document] = []
        if let selectedDoc = self.photoDocument {
            selectedDocs = [selectedDoc]
        }
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.postWithUploadMultipleFiles(selectedDocs, strURL: strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        let userDetail = response["data"] as! Dictionary<String, Any>
                        let object: UserDetail = UserDetail.initWith(dict: userDetail.removeNull())
                        
                        if let data = try? JSONEncoder().encode(object) {
                            defaults.set(data, forKey: kLoggedInUserData)
                            defaults.synchronize()
                            
                            objUserDetail = object
                            
                            strongSelf.btnUpdate.isUserInteractionEnabled = true
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnUpdate.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnUpdate.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnUpdate.isUserInteractionEnabled = true
        }
    }
}

