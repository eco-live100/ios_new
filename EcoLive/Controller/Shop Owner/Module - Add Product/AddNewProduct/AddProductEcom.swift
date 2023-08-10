//
//  ViewController.swift
//  DemoApp
//
//  Created by Ishan Jha on 08/11/22.
//

import UIKit
import Photos
import MobileCoreServices
import DropDown

struct ProductImage {
    var imgUrl = ""
    var image = UIImage()
    var id = ""
}

class clViewImagesProduct : UICollectionViewCell{
    @IBOutlet weak var imgMainProduct: UIImageView!
}



class AddProductEcom: UIViewController {

    static func getObject()-> AddProductEcom {
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddProductEcom") as? AddProductEcom
        if let vc = vc {
            return vc
        }
        return AddProductEcom()
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

    @IBOutlet weak var txtColorCode: UITextField!



    @IBOutlet weak var imgStatusActive: UIImageView!
    @IBOutlet weak var imgStatusDeactive: UIImageView!


    var arProductImage : [ProductImage] = []
    private var myDropDown = DropDown()

    var apiAttributesData = NSArray()
    var subCatData = NSDictionary()



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
        callProductAttributeFormAPI()

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

    @IBAction func btnSelectProductSubCetegoryAction(_ sender: UIButton) {

        var subCatName : [String] = []
        for i in apiAttributesData {
            if let dic = i as? NSDictionary {
                if let name = dic["subCategoryName"] as? String {
                    subCatName.append(name)
                }
            }
        }
        let arrCategory = subCatName
        dropDownBasicStyle(sender, arrCategory: arrCategory)
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.txtProductSubCategory.text = item
            self.subCatData = self.apiAttributesData[index] as! NSDictionary
        }
        myDropDown.show()
    }

    @IBAction func btnSelectBrandTypeAction(_ sender: UIButton) {

        var subCatName : [String] = []

        let atr = ((((self.subCatData["attributes"] as! NSArray).filter({($0 as! NSDictionary)["field"] as! String == "brand"})).first) as? NSDictionary)?["data"] as! NSArray
        for i in atr {
            if let name = i as? String {
                subCatName.append(name)
            }
        }
        let arrCategory = subCatName
        dropDownBasicStyle(sender, arrCategory: arrCategory)
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.txtBrandTypeName.text = item
        }
        myDropDown.show()

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

        var subCatName : [String] = []

        let atr = ((((self.subCatData["attributes"] as! NSArray).filter({($0 as! NSDictionary)["field"] as! String == "productFor"})).first) as? NSDictionary)?["data"] as! NSArray
        for i in atr {
            if let name = i as? String {
                subCatName.append(name)
            }
        }
        let arrCategory = subCatName
        dropDownBasicStyle(sender, arrCategory: arrCategory)
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.txtProductFor.text = item
        }
        myDropDown.show()

    }
    @IBAction func btnSelectProductCetegoryAction(_ sender: UIButton) {


    }


    @IBAction func btnSelectProductSizeAction(_ sender: UIButton) {

        var subCatName : [String] = []

        let atr = ((((self.subCatData["attributes"] as! NSArray).filter({($0 as! NSDictionary)["field"] as! String == "size"})).first) as? NSDictionary)?["data"] as! NSArray
        for i in atr {
            if let name = i as? String {
                subCatName.append(name)
            }
        }
        let arrCategory = subCatName
        dropDownBasicStyle(sender, arrCategory: arrCategory)
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.txtProductSize.text = item
        }
        myDropDown.show()

    }
    @IBAction func btnSelectProductQtyAction(_ sender: UIButton) {

        var arrCategory = [String]()
        for i in 1 ..< 20 {
            arrCategory.append(String(i))
        }
        dropDownBasicStyle(sender, arrCategory: arrCategory)
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.txtProductQty.text = item
        }
        myDropDown.show()
    }

    @IBAction func btnSelectProductProcessingTimeDayAction(_ sender: UIButton) {

        let arrCategory = ["5","6","7","8","9","10","11","12","13"]
        dropDownBasicStyle(sender, arrCategory: arrCategory)
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.txtProductProcessingTime.text = item
        }
        myDropDown.show()

    }


    @IBAction func btnSelectProductStatus(_ sender: UIButton) {
        if sender.tag == 1 {
            imgStatusActive.image = UIImage(named: "CheckWhatup")
            imgStatusDeactive.image = UIImage(named: "Uncheck")
        }else if sender.tag == 2{
            imgStatusActive.image = UIImage(named: "Uncheck")
            imgStatusDeactive.image = UIImage(named: "CheckWhatup")
        }
    }

    @IBAction func btnSaveProductAction(_ sender: UIButton) {
//        val brand: String,
//        val subCatogary: String,
//        val price: String,
//        val priceLive: String
//        val productDis: String
//        val productTimeDelivery: String

        // #21FF00

        guard let name = txtProductName.text else { return  }
        guard let color = txtColorCode.text else { return  }
////        guard let brand = txtBrandTypeName.text else { return  }
//        guard let productFor = txtProductFor.text else { return  }
//        guard let skuNo = txtProductSkuNo.text else { return  }
////        guard let subCatogary = txtBrandTypeName.text else { return  }
//        guard let price = txtProductPrice.text else { return  }
//        guard let priceLive = txtProductSellingPrice.text else { return  }

        let colorArray = color.components(separatedBy: ",").map({($0 as? String)?.trimmingCharacters(in: .whitespaces)})

        let productParamsDummy = ["subCatogary" : txtProductSubCategory.text ?? "",
                                  "price"  :txtProductPrice.text ?? "",
                                  "priceLive" : txtProductSellingPrice.text ?? "",
                                  "productName" : name,
                                  "color" : colorArray,
                                  "brand" : "nike",
                                  "productFor" : txtProductFor.text ?? "",
                                  "productSize" : txtProductSize.text ?? "",
                                  "skuNo" : txtProductSkuNo.text ?? "",
                                  "discription" : txtProductDescription.text ?? "",
//                                  "productTimeDelivery" : txt

        ] as [String : Any]

        let params = ["shopCategoryId" : myShop.shopCategoryID,//self.mainData[0].shopCategoryID ,
                      "shopSubCategoryId" : "638638170511c963fb9bb119", //myShop.shopSubCategoryID, //self.mainData[0].shopSubCategoryID ,
                      "vendorShopId" : myShop._id ,
                      "productData" : productParamsDummy
        ] as! [String : Any]

        self.callAddProductFormDataAPI(parm: params)

    }

    @IBAction func btnResetProductAction(_ sender: UIButton) {

    }

    @IBAction func btnColorPiker(_ sender: UIButton) {

        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {

        }


    }



}

extension AddProductEcom: UIColorPickerViewControllerDelegate {

    //  Called once you have finished picking the color.
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {

        let oldCode = txtColorCode.text ?? ""
        if oldCode.count > 0 {
            txtColorCode.text = oldCode + ", " + viewController.selectedColor.toHexString()
        }else{
            txtColorCode.text = viewController.selectedColor.toHexString()
        }

//        self.view.backgroundColor = viewController.selectedColor

    }

    //  Called on every color selection done in the picker.
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        var oldCode = txtColorCode.text ?? ""
        if oldCode.count > 0 {
            let newCode = viewController.selectedColor.toHexString()
//            oldCode = oldCode.replaceOccurrences(of: newCode, with: "")
            txtColorCode.text = oldCode + ", " + newCode
        }else{
            txtColorCode.text = viewController.selectedColor.toHexString()
        }    }
}

//MARK: - SHOW MEDIA PICKER OPTIONS -

extension AddProductEcom {

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

extension AddProductEcom: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

extension AddProductEcom {




    //MARK: - API CALL
    func callProductAttributeFormAPI() {

        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }

//        let params = ["shopId" : myShop._id
//        ] as! [String : Any]
        let params = ["shopId" : "638383f8df3a3f2b49583b84"
        ] as! [String : Any]

        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.GETSTOREATTRIBUTE, parameters: params) { responce in
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                if(isSuccess == 200){

                    if let payloadData = jsondata["data"] as? NSArray {
                        self.apiAttributesData = payloadData
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


    func callAddProductFormDataAPI (parm : [String : Any]){
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)

        var sendFiles : [SSFiles] = []

        for i in 0 ..< self.arProductImage.count {
            let vDocument : SSFiles = SSFiles(image: arProductImage[i].image, paramKey: "images")
            sendFiles.append(vDocument)
        }

        NetworkManager.callServiceMultipalFiles(url: NetworkManager.New_API_DIR + Constants.URLS.ADD_PRODUCT, files: sendFiles, parameters: parm) { responce in
            GlobalData.shared.hideProgress()
            switch responce {
            case .success(let jsondata):
                let isSuccess:Int = jsondata["statusCode"] as! Int
                let message:String = jsondata["message"] as? String ?? ""

                if(isSuccess == 201){
                    //                    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsondata, options: .prettyPrinted),
                    //                          let user = try? JSONDecoder().decode(ProductAttributeModel.self, from: jsonData) else { return }
                    //                    self.mainData = user.data

                    self.navigationController?.popViewController(animated: true)
                    GlobalData.shared.showDarkStyleToastMesage(message: message)

                    do {
                        let jsonNew = try JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
                        print(jsonNew)


                        //                        let jsonN = try JSONDecoder().decode(ProductAttributeModel.self, from: jsonNew)
                        //                        self.mainData = jsonN.data
                    } catch let error {
                        print(error)
                        print(error.localizedDescription)
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

        //        NetworkManager.callService(url: NetworkManager.New_API_DIR + Constants.URLS.ADD_PRODUCT, parameters: parm) { responce in
        //            GlobalData.shared.hideProgress()
        //            switch responce {
        //            case .success(let jsondata):
        //                let isSuccess:Int = jsondata["statusCode"] as! Int
        //                if(isSuccess == 201){
        //                    //                    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsondata, options: .prettyPrinted),
        //                    //                          let user = try? JSONDecoder().decode(ProductAttributeModel.self, from: jsonData) else { return }
        //                    //                    self.mainData = user.data
        //                    do {
        //                        let jsonNew = try JSONSerialization.data(withJSONObject: jsondata , options: .prettyPrinted)
        //                        print(jsonNew)
        ////                        let jsonN = try JSONDecoder().decode(ProductAttributeModel.self, from: jsonNew)
        ////                        self.mainData = jsonN.data
        //                    } catch let error {
        //                        print(error)
        //                        print(error.localizedDescription)
        //                    }
        //                }
        //
        //            case .failed(let errorMessage):
        //                switch errorMessage {
        //                default:
        //                    self.handleDefaultResponse(errorMessage: errorMessage)
        //                    break
        //                }
        //            }
        //        }
    }
}
extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
