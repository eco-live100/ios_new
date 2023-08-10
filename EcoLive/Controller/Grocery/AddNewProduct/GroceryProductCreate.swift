//
//  GroceryProductCreate.swift
//  EcoLive
//
//  Created by  on 26/11/22.
//

import UIKit
import DropDown
import Photos
import MobileCoreServices

class GroceryProductCreate: UIViewController {

    static func getObject()-> GroceryProductCreate {
        let storyboard = UIStoryboard(name: "GroceryBord", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GroceryProductCreate") as? GroceryProductCreate
        if let vc = vc {
            return vc
        }
        return GroceryProductCreate()
    }

    var myShop : ShopObject!
    var productName = ""

    enum SelectImageType {
        case Main
        case Add
    }
    var selectImageMode : SelectImageType = .Add

    // Main Image Product
    @IBOutlet weak var imgMainProduct: UIImageView!
    @IBOutlet weak var clViewImagesCollection: UICollectionView!

    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtBrandTypeName: UITextField!
    @IBOutlet weak var txtProductBrandName: UITextField!
    @IBOutlet weak var txtProductFor: UITextField!
    @IBOutlet weak var txtProductCategory: UITextField!
    @IBOutlet weak var txtProductSubCategory: UITextField!
    @IBOutlet weak var txtProductSize: UITextField!
    @IBOutlet weak var txtProductQty: UITextField!
    @IBOutlet weak var txtProductSkuNo: UITextField!
    @IBOutlet weak var txtProductDescription: UITextField!
    @IBOutlet weak var txtProductProcessingTime: UITextField!
    @IBOutlet weak var txtProductPrice: UITextField!
    @IBOutlet weak var txtProductSellingPrice: UITextField!
    @IBOutlet weak var txtProductComission: UITextField!
    @IBOutlet weak var txtProductVat: UITextField!
    @IBOutlet weak var txtProductDeliveryCharge: UITextField!
    @IBOutlet weak var txtProductDeliveryWithCharge: UITextField!

    @IBOutlet weak var txtSelectDate: UITextField!
    private var datePicker: UIDatePicker?



    @IBOutlet weak var imgStatusActive: UIImageView!
    @IBOutlet weak var imgStatusDeactive: UIImageView!


    var arProductImage : [ProductImage] = []
    private var myDropDown = DropDown()


    override func viewDidLoad() {
        super.viewDidLoad()

        setUIData()
    }

    func setUIData(){

        clViewImagesCollection.delegate = self
        clViewImagesCollection.dataSource = self

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnSelect(_:)))
        imgMainProduct.isUserInteractionEnabled = true
        imgMainProduct.addGestureRecognizer(imageTap)
    }


    @objc func handleTapOnSelect(_ sender: UITapGestureRecognizer? = nil){

        if arProductImage.count == 0 {
            selectImageMode = .Main
            self.showMediaPickerOptions()
        }


    }

    //MARK: - ACTIONS
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelectDateAction(_ sender: UIButton) {

        setupDatePicker()

    }

    private func dropDownBasicStyle(_ sender: UIButton,arrCategory : [String]){
        self.myDropDown = DropDown()
        self.myDropDown.backgroundColor = .white
        self.myDropDown.selectionBackgroundColor = .white
        self.myDropDown.textColor = .black
        self.myDropDown.selectedTextColor = .white
        self.myDropDown.anchorView = sender
        self.myDropDown.dataSource = arrCategory
        self.myDropDown.direction = .bottom
        self.myDropDown.textFont = UIFont.init(name: "Roboto-Regular", size: 15)!
        self.myDropDown.cellHeight = 42
    }

    @IBAction func btnSelectProductBrandAction(_ sender: UIButton) {

    }
    @IBAction func btnSelectProductForAction(_ sender: UIButton) {

    }
    @IBAction func btnSelectProductCetegoryAction(_ sender: UIButton) {

    }
    @IBAction func btnSelectProductSubCetegoryAction(_ sender: UIButton) {

    }

    @IBAction func btnSelectProductSizeAction(_ sender: UIButton) {

    }
    @IBAction func btnSelectProductQtyAction(_ sender: UIButton) {

    }

    @IBAction func btnSelectProductProcessingTimeDayAction(_ sender: UIButton) {

    }


    @IBAction func btnSelectProductStatus(_ sender: UIButton) {

    }

    @IBAction func btnSaveProductAction(_ sender: UIButton) {

    }

    @IBAction func btnResetProductAction(_ sender: UIButton) {

    }

}

extension GroceryProductCreate {

    private func setupDatePicker() {

        datePicker?.removeFromSuperview()

        let picker = datePicker ?? UIDatePicker()
        picker.datePickerMode = .date

        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let size = self.view.frame.size
        picker.frame = CGRect(x: 0.0, y: size.height - 200, width: size.width, height: 200)
        picker.backgroundColor = UIColor.white
        self.datePicker = picker
        self.view.addSubview(self.datePicker!)
    }

    @objc func dueDateChanged(sender:UIDatePicker){

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let date = datePicker?.date {
            let format = date.getFormattedDate(format: "dd/MM/YYYY")
            txtSelectDate.text = format
        }
        datePicker?.removeFromSuperview()
    }
}





//MARK: - SHOW MEDIA PICKER OPTIONS -

extension GroceryProductCreate {

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
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.imgMainProduct.frame.origin.y - 60, width: 0, height: 0) //sender.bounds
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
            //UIApplication.shared.openSettings()
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

extension GroceryProductCreate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //        let image = info[.originalImage] as! UIImage
        let image = info[.editedImage] as! UIImage
        let data = image.jpegData(compressionQuality: 0.5)!
        //        self.imgMainProduct.image = image
        //        self.imgMainProduct.contentMode = .scaleAspectFill

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

        //        let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_profileImage.jpg"
        //        let document = Document(
        //            uploadParameterKey: "profileImage",
        //            data: data,
        //            name: name ?? filename,
        //            fileName: filename,
        //            mimeType: "image/jpeg"
        //        )
        //        self.photoDocument = document

        arProductImage.append(ProductImage(image: image,id: String(arProductImage.count+1)))
        clViewImagesCollection.reloadData()

        //        if selectImageMode == .Add {
        //
        //        }else{
        //            arProductImage.append(ProductImage(image: image,id: String(arProductImage.count+1)))
        //            clViewImagesCollection.reloadData()
        //        }

        picker.dismiss(animated: true, completion: nil)
    }
}
