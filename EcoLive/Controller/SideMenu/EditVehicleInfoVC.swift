//
//  EditVehicleInfoVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 23/08/21.
//

import UIKit
import SwiftyJSON
import SwiftValidators
import DropDown
import Photos
import MobileCoreServices
import SDWebImage

class EditVehicleInfoVC: UIViewController {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var viewUploadFile: CustomDashedView!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var categoryDropDown = DropDown()
    var photoDocument: Document?
    
    var arrVehicleCategory: [VehicleCategoryObject] = []
    var selectedVehicleCategory = ""
    
    var arrVehicleList: [VehicleObject] = []
    
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
        let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageDocumentClick(_:)))
        self.imgDocument.addGestureRecognizer(objGesture)
        self.imgDocument.isUserInteractionEnabled = true
        self.imgDocument.contentMode = .scaleAspectFit
        self.imgDocument.image = UIImage.init(named: "ic_placeholder")
        
        DispatchQueue.main.async {
            self.viewCategory.layer.cornerRadius = self.viewCategory.frame.height / 2.0
            self.viewCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewCategory.layer.borderWidth = 1.0
            
            self.btnUpdate.layer.cornerRadius = self.btnUpdate.frame.height / 2.0
            self.btnUpdate.createButtonShadow()
        }
        
        //FETCH VEHICLE CATEGORY DATA
        if let data = defaults.value(forKey: configurationData) as? Data,
            let configData = try? JSONDecoder().decode(UtilityObject.self, from: data) {
            GlobalData.shared.objConfiguration = configData
            
            self.arrVehicleCategory = GlobalData.shared.objConfiguration.arrVehicleCategory
        }
        
        self.callGetVehicleInfoAPI()
    }
    
    //MARK: - HELPER -
    
    func setupCategoryDropDown() {
        self.categoryDropDown = DropDown()
        let arrCategory = self.arrVehicleCategory.map { $0.name }
        
        self.categoryDropDown.backgroundColor = .white
        self.categoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.categoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.categoryDropDown.selectedTextColor = .white
        
        self.categoryDropDown.anchorView = self.viewCategory
        self.categoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.categoryDropDown.anchorView?.plainView.bounds.height)! + 25))
        self.categoryDropDown.dataSource = arrCategory
        self.categoryDropDown.direction = .bottom
        self.categoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.categoryDropDown.cellHeight = 42
        
        if self.txtCategory.text != "" {
            guard let index = arrCategory.firstIndex(of: self.txtCategory.text!) else { return }
            self.categoryDropDown.selectRow(index, scrollPosition: .top)
        }
        
        self.categoryDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            self.txtCategory.text = item
            self.selectedVehicleCategory = self.arrVehicleCategory[index]._id
        }
    }
    
    @objc func imageDocumentClick(_ sender:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        self.showMediaPickerOptions()
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVehicleCategoryClick(_ sender: UIButton) {
        self.categoryDropDown.show()
    }
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        if self.txtCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Category is required")
        } else if self.imgDocument.image == nil || self.imgDocument.image == UIImage.init(named: "ic_placeholder") {
            GlobalData.shared.showDarkStyleToastMesage(message: "Vehicle’s appropriate documents is required")
        } else {
            self.btnUpdate.isUserInteractionEnabled = false
            self.callUpdateVehicleInfoAPI()
        }
    }
}

//MARK: - SHOW MEDIA PICKER OPTIONS -

extension EditVehicleInfoVC {
    
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

extension EditVehicleInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        let image = info[.originalImage] as! UIImage
        let image = info[.editedImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!
        self.imgDocument.image = image
        self.imgDocument.contentMode = .scaleAspectFill
        
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
        self.photoDocument = document
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API CALL -

extension EditVehicleInfoVC {
    
    //GET VEHICLE INFORMATION
    func callGetVehicleInfoAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["user_id"] = objUserDetail._id
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestPOSTURL(Constants.URLS.VEHICLE_INFORMATION, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objVehicle = VehicleObject.init(payloadData[i])
                                strongSelf.arrVehicleList.append(objVehicle)
                            }
                            
                            if strongSelf.arrVehicleList.count > 0 {
                                let objFirstData = strongSelf.arrVehicleList[0]
                                strongSelf.txtCategory.text = objFirstData.vehicalName
                                strongSelf.selectedVehicleCategory = objFirstData.category

                                strongSelf.imgDocument.sd_setImage(with: URL(string: objFirstData.image), placeholderImage: UIImage.init(named: "ic_placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { (img, err, cacheType, imgURL) in
                                    
                                    guard let data = strongSelf.imgDocument.image?.jpegData(compressionQuality: 0.5)! else { return }
                                    
                                    let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_vehicalImage.jpg"
                                    let document = Document(
                                        uploadParameterKey: "vehicalImage",
                                        data: data,
                                        name: filename,
                                        fileName: filename,
                                        mimeType: "image/jpeg"
                                    )
                                    strongSelf.photoDocument = document
                                })
                            }
                            
                            strongSelf.setupCategoryDropDown()
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
    
    //UPDATE VEHICLE INFORMATION
    func callUpdateVehicleInfoAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var vehicleID = ""
        
        if self.arrVehicleList.count > 0 {
            let objFirstData = self.arrVehicleList[0]
            vehicleID = objFirstData._id
        }
        let strURL = Constants.URLS.VEHICLE_INFORMATION + "/" + "\(vehicleID)"
        
        var params: [String:Any] = [:]
        params["vehicalName"] = self.txtCategory.text ?? ""
        params["category"] = self.selectedVehicleCategory
        
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
                        strongSelf.navigationController?.popViewController(animated: true)
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
