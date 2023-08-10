//
//  AddShopInfoVC.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 10/06/21.
//

import UIKit
import DropDown
import Photos
import MobileCoreServices
import SwiftValidators
import SwiftyJSON
import Colorful
import SDWebImage
import GooglePlaces
import LabelSwitch

class AddShopInfoVC: BaseVC {

    //MARK: - PROPERTIES & OUTLETS -
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblNavTitle: UILabel!
    
    @IBOutlet weak var btnShopInfo: UIButton!
    @IBOutlet weak var btnProduct: UIButton!
    @IBOutlet weak var imgProgress: UIImageView!
    @IBOutlet weak var imgProgressHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    //SHOP INFORMATION
    @IBOutlet weak var viewShopStep1: UIView!
    @IBOutlet weak var imgShopLogo: UIImageView!
    @IBOutlet weak var btnUploadShopStep1: UIButton!
    @IBOutlet weak var btnCancelShopStep1: UIButton!
    
    @IBOutlet weak var viewShopStep2: UIView!
    @IBOutlet weak var txtName: PaddingTextField!
    @IBOutlet weak var txtEmail: PaddingTextField!
    @IBOutlet weak var txtPassword: PaddingTextField!
    @IBOutlet weak var txtShopName: PaddingTextField!
    @IBOutlet weak var btnNextShopStep2: UIButton!
    
    @IBOutlet weak var viewShopStep3: UIView!
    @IBOutlet weak var txtShopCategory: PaddingTextField!
    @IBOutlet weak var imgCategoryDropdown: UIImageView!
    @IBOutlet weak var txtShopDescription: KMPlaceholderTextView!
    @IBOutlet weak var txtShopAddress: PaddingTextField!
    @IBOutlet weak var txtShopZipcode: PaddingTextField!
    @IBOutlet weak var btnUploadShopStep3: UIButton!
    
    //PRODUCT
    @IBOutlet weak var viewProductList: UIView!
    @IBOutlet weak var btnAddProduct: UIButton!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var viewProductStep1: UIView!
    @IBOutlet weak var clViewProduct: UICollectionView!
    @IBOutlet weak var btnUploadProductStep1: UIButton!
    @IBOutlet weak var btnCancelProductStep1: UIButton!
    
    @IBOutlet weak var viewProductStep2: UIView!
    @IBOutlet weak var txtProductName: PaddingTextField!
    @IBOutlet weak var txtProductCategory: PaddingTextField!
    @IBOutlet weak var imgProductCategoryDropdown: UIImageView!
    @IBOutlet weak var txtSubProductCategory: PaddingTextField!
    @IBOutlet weak var imgSubProductCategoryDropdown: UIImageView!
    @IBOutlet weak var txtProductQty: PaddingTextField!
    @IBOutlet weak var switchLiveDelivery: LabelSwitch!
    @IBOutlet weak var switchOnlineDelivery: LabelSwitch!
    @IBOutlet weak var btnNextProductStep2: UIButton!
    
    @IBOutlet weak var viewProductStep3: UIView!
    @IBOutlet weak var txtProductDescription: KMPlaceholderTextView!
    @IBOutlet weak var txtProductLivePrice: PaddingTextField!
    @IBOutlet weak var txtProductOnlinePrice: PaddingTextField!
    @IBOutlet weak var viewProductColor: UIView!
    @IBOutlet weak var clViewColor: UICollectionView!
    @IBOutlet weak var txtProductDeliveryType: PaddingTextField!
    @IBOutlet weak var btnUploadProductStep3: UIButton!
    
    //COLOR PICKER POPUP
    @IBOutlet weak var viewPopupColorPicker: UIView!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var imgPickedColor: UIImageView!
    @IBOutlet weak var txtColorName: PaddingTextField!
    
    var strShopID = ""
    var objShopDetail = ShopObject.init([:])
    
    var colorSpace: HRColorSpace = .sRGB
    var colorHexCode = ""
    var arrProductColor: [ColorDataObject] = []
    var colorJsonString: String!
    
    var shopLogoDocument: Document?
    var shopCategoryDropDown = DropDown()
    
    var isSelectShop:Bool = true
    var isSelectShopLogo:Bool = true
    var stepNo:Int = 1
    
    var arrProductImages: [UIImage] = []
    var productImageDocument: [Document] = []
    var arrProductCategory: [ProductCategoryObject] = []
    var arrSubProductCategory: [SubProductCategoryObject] = []
    var productCategoryDropDown = DropDown()
    var subProductCategoryDropDown = DropDown()
    
    var arrShopCategory: [ShopCategoryObject] = []
    
    var selectedShopCategory = ""
    var selectedProductCategory = ""
    var selectedSubProductCategory = ""
    
    var productLiveDelivery:Bool = false
    var productOnlineDelivery:Bool = false
    
    var strLattitude = ""
    var strLongitude = ""
    
    var arrProductList: [ProductObject] = []
    var objProductToEdit: ProductObject!
    var isEditProduct:Bool = false
        
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
        
        self.lblNavTitle.text = "Upload logo"
        
        self.btnShopInfo.backgroundColor = UIColor.init(hex: 0xD4D4D4)
        self.btnShopInfo.setTitleColor(UIColor.init(hex: 0x333333), for: [])
        
        self.btnProduct.backgroundColor = UIColor.clear
        self.btnProduct.setTitleColor(UIColor.init(hex: 0x9F9F9F), for: [])
        
        self.stepNo = 1
        self.imgProgress.image = UIImage.init(named: "ic_step1")
        self.imgProgressHeightConstraint.constant = 35
        
        /*let tempStack = UIStackView()
        tempStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        tempStack.addArrangedSubview(self.viewShopStep1) */
        
        self.viewShopStep1.frame.size.height = self.containerView.frame.size.height
        self.containerView.subviews.forEach({ $0.removeFromSuperview() })
        self.containerView.addSubview(self.viewShopStep1)
        
        let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageShopLogoClick(_:)))
        self.imgShopLogo.addGestureRecognizer(objGesture)
        self.imgShopLogo.isUserInteractionEnabled = true
        self.imgShopLogo.image = #imageLiteral(resourceName: "ic_upload_logo")
        self.imgShopLogo.contentMode = .scaleAspectFit
        
        self.tblView.showsVerticalScrollIndicator = false
        self.tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 1))
        
        if self.arrProductList.count > 0 {
            self.lblNoRecord.isHidden = true
            self.tblView.isHidden = false
        } else {
            self.lblNoRecord.isHidden = false
            self.tblView.isHidden = true
        }
        
        self.viewPopupColorPicker.isHidden = true
        
        self.colorPicker.addTarget(self, action: #selector(self.handleColorChanged(picker:)), for: .valueChanged)
        self.colorPicker.set(color: UIColor(displayP3Red: 1.0, green: 1.0, blue: 0, alpha: 1), colorSpace: self.colorSpace)
        self.handleColorChanged(picker: self.colorPicker)
        
        //FETCH SHOP CATEGORY DATA
        if let data = defaults.value(forKey: configurationData) as? Data,
            let configData = try? JSONDecoder().decode(UtilityObject.self, from: data) {
            GlobalData.shared.objConfiguration = configData
            
            self.arrShopCategory = GlobalData.shared.objConfiguration.arrShopCategory
        }
        
        let objShopCategory = self.arrShopCategory.filter{ $0._id == self.objShopDetail.category}.first
        
        if self.objShopDetail.image != "" {
            self.imgShopLogo.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgShopLogo.sd_setImage(with: URL(string: self.objShopDetail.image), placeholderImage: UIImage.init(named: "ic_upload_logo"))
            
            guard let data = self.imgShopLogo.image?.jpegData(compressionQuality: 0.5)! else { return }
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_shop_image.jpg"
            let document = Document(
                uploadParameterKey: "image",
                data: data,
                name: filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.shopLogoDocument = document
        }
        
        self.txtName.text = objUserDetail.userName
        self.txtEmail.text = objUserDetail.email
        self.txtPassword.text = "......"
        self.txtShopName.text = self.objShopDetail.shopName
        
        self.txtShopCategory.text = objShopCategory?.name
        self.selectedShopCategory = objShopCategory?._id ?? ""
        self.txtShopDescription.text = self.objShopDetail.shopDescription
        self.txtShopAddress.text = self.objShopDetail.address
        self.txtShopZipcode.text = self.objShopDetail.zipCode
        
        self.strLattitude = self.objShopDetail.latitude
        self.strLongitude = self.objShopDetail.longitude
        
        self.switchLiveDelivery.delegate = self
        self.switchLiveDelivery.circleShadow = false
        self.switchLiveDelivery.fullSizeTapEnabled = true
        
        self.switchOnlineDelivery.delegate = self
        self.switchOnlineDelivery.circleShadow = false
        self.switchOnlineDelivery.fullSizeTapEnabled = true
        
        DispatchQueue.main.async {
            self.viewTop.layer.masksToBounds = false
            self.viewTop.layer.shadowRadius = 1
            self.viewTop.layer.shadowOpacity = 0.6
            self.viewTop.layer.shadowColor = UIColor.init(hex: 0x000000, a: 0.3).cgColor
            self.viewTop.layer.shadowOffset = CGSize(width: 0, height: 3)
            
            //SHOP INFORMATION
            self.txtName.layer.cornerRadius = self.txtName.frame.height / 2.0
            self.txtName.layer.borderWidth = 1.0

            self.txtEmail.layer.cornerRadius = self.txtEmail.frame.height / 2.0
            self.txtEmail.layer.borderWidth = 1.0

            self.txtPassword.layer.cornerRadius = self.txtPassword.frame.height / 2.0
            self.txtPassword.layer.borderWidth = 1.0

            self.txtShopName.layer.cornerRadius = self.txtShopName.frame.height / 2.0
            self.txtShopName.layer.borderWidth = 1.0

            self.txtShopCategory.layer.cornerRadius = self.txtShopCategory.frame.height / 2.0
            self.txtShopCategory.layer.borderWidth = 1.0

            self.txtShopDescription.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 8)

            self.txtShopAddress.layer.cornerRadius = self.txtShopAddress.frame.height / 2.0
            self.txtShopAddress.layer.borderWidth = 1.0

            self.txtShopZipcode.layer.cornerRadius = self.txtShopZipcode.frame.height / 2.0
            self.txtShopZipcode.layer.borderWidth = 1.0
            
            self.btnUploadShopStep1.layer.cornerRadius = self.btnUploadShopStep1.frame.height / 2.0
            self.btnUploadShopStep1.createButtonShadow()
            
            self.btnCancelShopStep1.layer.cornerRadius = self.btnCancelShopStep1.frame.height / 2.0
            self.btnCancelShopStep1.createButtonShadow()
            
            self.btnNextShopStep2.layer.cornerRadius = self.btnNextShopStep2.frame.height / 2.0
            self.btnNextShopStep2.createButtonShadow()

            self.btnUploadShopStep3.layer.cornerRadius = self.btnUploadShopStep3.frame.height / 2.0
            self.btnUploadShopStep3.createButtonShadow()
            
            //PRODUCT
            self.txtProductName.layer.cornerRadius = self.txtProductName.frame.height / 2.0
            self.txtProductName.layer.borderWidth = 1.0

            self.txtProductCategory.layer.cornerRadius = self.txtProductCategory.frame.height / 2.0
            self.txtProductCategory.layer.borderWidth = 1.0
            
            self.txtSubProductCategory.layer.cornerRadius = self.txtSubProductCategory.frame.height / 2.0
            self.txtSubProductCategory.layer.borderWidth = 1.0

            self.txtProductQty.layer.cornerRadius = self.txtProductQty.frame.height / 2.0
            self.txtProductQty.layer.borderWidth = 1.0

            self.txtProductDescription.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 8)
            
            self.txtProductLivePrice.layer.cornerRadius = self.txtProductLivePrice.frame.height / 2.0
            self.txtProductLivePrice.layer.borderWidth = 1.0
            
            self.txtProductOnlinePrice.layer.cornerRadius = self.txtProductOnlinePrice.frame.height / 2.0
            self.txtProductOnlinePrice.layer.borderWidth = 1.0
            
            self.txtProductDeliveryType.layer.cornerRadius = self.txtProductDeliveryType.frame.height / 2.0
            self.txtProductDeliveryType.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.txtProductDeliveryType.layer.borderWidth = 1.0
            
            self.viewProductColor.layer.cornerRadius = self.viewProductColor.frame.height / 2.0
            self.viewProductColor.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            self.viewProductColor.layer.borderWidth = 1.0
            
            self.btnAddProduct.layer.cornerRadius = self.btnAddProduct.frame.height / 2.0
            self.btnAddProduct.createButtonShadow()
            
            self.btnUploadProductStep1.layer.cornerRadius = self.btnUploadProductStep1.frame.height / 2.0
            self.btnUploadProductStep1.createButtonShadow()
            
            self.btnCancelProductStep1.layer.cornerRadius = self.btnCancelProductStep1.frame.height / 2.0
            self.btnCancelProductStep1.createButtonShadow()
            
            self.btnNextProductStep2.layer.cornerRadius = self.btnNextProductStep2.frame.height / 2.0
            self.btnNextProductStep2.createButtonShadow()
            
            self.btnUploadProductStep3.layer.cornerRadius = self.btnUploadProductStep3.frame.height / 2.0
            self.btnUploadProductStep3.createButtonShadow()
            
            self.setupTextfield()
        }
        
        self.txtName.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.txtPassword.isUserInteractionEnabled = false
        self.txtShopCategory.isUserInteractionEnabled = false
        self.txtShopAddress.isUserInteractionEnabled = false
        
        self.txtProductCategory.isUserInteractionEnabled = false
        self.txtSubProductCategory.isUserInteractionEnabled = false
        
        self.setupShopCategoryDropDown()
        
        self.callProductCategoryAPI()
    }
    
    func setupTextfield() {
        if self.txtName.text != "" {
            self.txtName.setUpImage(imageName: "ic_true", on: .right)
            self.txtName.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtName.setUpImage(imageName: "", on: .right)
            self.txtName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtEmail.text != "" {
            self.txtEmail.setUpImage(imageName: "ic_true", on: .right)
            self.txtEmail.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtEmail.setUpImage(imageName: "", on: .right)
            self.txtEmail.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtPassword.text != "" {
            self.txtPassword.setUpImage(imageName: "ic_true", on: .right)
            self.txtPassword.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtPassword.setUpImage(imageName: "", on: .right)
            self.txtPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtShopName.text != "" {
            self.txtShopName.setUpImage(imageName: "ic_true", on: .right)
            self.txtShopName.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtShopName.setUpImage(imageName: "", on: .right)
            self.txtShopName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtShopCategory.text != "" {
            self.imgCategoryDropdown.image = self.imgCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
            self.imgCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
            self.txtShopCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.imgCategoryDropdown.image = self.imgCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
            self.imgCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
            self.txtShopCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtShopDescription.text != "" {
            self.txtShopDescription.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtShopDescription.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtShopAddress.text != "" {
            self.txtShopAddress.setUpImage(imageName: "ic_true", on: .right)
            self.txtShopAddress.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtShopAddress.setUpImage(imageName: "", on: .right)
            self.txtShopAddress.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtShopZipcode.text != "" {
            self.txtShopZipcode.setUpImage(imageName: "ic_true", on: .right)
            self.txtShopZipcode.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtShopZipcode.setUpImage(imageName: "", on: .right)
            self.txtShopZipcode.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
    }
    
    func removeSetData() {
        self.arrProductImages = []
        self.productImageDocument = []
        self.txtProductName.text = ""
        self.txtProductCategory.text = ""
        self.selectedProductCategory = ""
        self.txtSubProductCategory.text = ""
        self.selectedSubProductCategory = ""
        self.txtProductQty.text = ""
        self.switchLiveDelivery.curState = .L
        self.switchLiveDelivery.circleColor = .white
        self.switchOnlineDelivery.curState = .L
        self.switchOnlineDelivery.circleColor = .white
        self.productLiveDelivery = false
        self.productOnlineDelivery = false
        self.txtProductDescription.text = ""
        self.txtProductLivePrice.text = ""
        self.txtProductOnlinePrice.text = ""
        
        DispatchQueue.main.async {
            self.setupTextfield()
        }
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewProduct)
    }
    
    @objc func handleColorChanged(picker: ColorPicker) {
        let uiColor = UIColor.init(cgColor: picker.color.cgColor)
        self.colorHexCode = uiColor.toHexString()
        debugPrint("Final Hex String is:- \(self.colorHexCode)")
        
        self.imgPickedColor.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: self.colorHexCode)
    }
    
    //MARK: - HELPER -
    
    func setupShopCategoryDropDown() {
        self.shopCategoryDropDown = DropDown()
        let arrCategory = self.arrShopCategory.map { $0.name }

        self.shopCategoryDropDown.backgroundColor = .white
        self.shopCategoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.shopCategoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.shopCategoryDropDown.selectedTextColor = .white

        self.shopCategoryDropDown.anchorView = self.txtShopCategory
        self.shopCategoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.shopCategoryDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.shopCategoryDropDown.dataSource = arrCategory
        self.shopCategoryDropDown.direction = .bottom
        self.shopCategoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.shopCategoryDropDown.cellHeight = 42

        if self.txtShopCategory.text != "" {
            guard let index = arrCategory.firstIndex(of: self.txtShopCategory.text!) else { return }
            self.shopCategoryDropDown.selectRow(index, scrollPosition: .top)
        }
        
        self.shopCategoryDropDown.selectionAction = { (index: Int, item: String) in
            debugPrint(item)
            self.txtShopCategory.text = item
            self.selectedShopCategory = self.arrShopCategory[index]._id
            
            if self.txtShopCategory.text != "" {
                self.imgCategoryDropdown.image = self.imgCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                self.imgCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
                self.txtShopCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.imgCategoryDropdown.image = self.imgCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                self.imgCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
                self.txtShopCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        }
    }
    
    func setupProductCategoryDropDown() {
        self.productCategoryDropDown = DropDown()
        let arrCategory = self.arrProductCategory.map { $0.name }
        
        self.productCategoryDropDown.backgroundColor = .white
        self.productCategoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.productCategoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.productCategoryDropDown.selectedTextColor = .white
        
        self.productCategoryDropDown.anchorView = self.txtProductCategory
        self.productCategoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.productCategoryDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.productCategoryDropDown.dataSource = arrCategory
        self.productCategoryDropDown.direction = .bottom
        self.productCategoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.productCategoryDropDown.cellHeight = 42
        
//        guard let index = arrCategory.firstIndex(of: self.txtProductCategory.text ?? "Product 1") else { return }
//        self.productCategoryDropDown.selectRow(index, scrollPosition: .top)
        
        self.productCategoryDropDown.selectionAction = { (index: Int, item: String) in
            self.txtProductCategory.text = item
            self.selectedProductCategory = self.arrProductCategory[index]._id
            
            if self.txtProductCategory.text != "" {
                self.imgProductCategoryDropdown.image = self.imgProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                self.imgProductCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
                self.txtProductCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.imgProductCategoryDropdown.image = self.imgProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                self.imgProductCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
                self.txtProductCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
            
            self.txtSubProductCategory.text = ""
            self.selectedSubProductCategory = ""
            self.callSubProductCategoryAPI()
        }
    }
    
    func setupSubProductCategoryDropDown() {
        self.subProductCategoryDropDown = DropDown()
        let arrSubCategory = self.arrSubProductCategory.map { $0.name }
        
        self.subProductCategoryDropDown.backgroundColor = .white
        self.subProductCategoryDropDown.selectionBackgroundColor = Constants.Color.THEME_YELLOW
        self.subProductCategoryDropDown.textColor = Constants.Color.THEME_BLACK
        self.subProductCategoryDropDown.selectedTextColor = .white
        
        self.subProductCategoryDropDown.anchorView = self.txtSubProductCategory
        self.subProductCategoryDropDown.bottomOffset = CGPoint(x: 0, y:((self.subProductCategoryDropDown.anchorView?.plainView.bounds.height)! + 10))
        self.subProductCategoryDropDown.dataSource = arrSubCategory
        self.subProductCategoryDropDown.direction = .bottom
        self.subProductCategoryDropDown.textFont = UIFont.init(name: Constants.Font.ROBOTO_MEDIUM, size: 15)!
        self.subProductCategoryDropDown.cellHeight = 42
        
//        guard let index = arrSubCategory.firstIndex(of: self.txtSubProductCategory.text ?? "SubProduct 1") else { return }
//        self.subProductCategoryDropDown.selectRow(index, scrollPosition: .top)
        
        self.subProductCategoryDropDown.selectionAction = { (index: Int, item: String) in
            self.txtSubProductCategory.text = item
            self.selectedSubProductCategory = self.arrSubProductCategory[index]._id
            
            if self.txtSubProductCategory.text != "" {
                self.imgSubProductCategoryDropdown.image = self.imgSubProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                self.imgSubProductCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
                self.txtSubProductCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.imgSubProductCategoryDropdown.image = self.imgSubProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                self.imgSubProductCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
                self.txtSubProductCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        }
    }
    
    @objc func imageShopLogoClick(_ sender:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        
        self.isSelectShopLogo = true
        self.showMediaPickerOptions()
    }
    
    func showProductStep1() {
        self.lblNavTitle.text = "Upload image"
        self.stepNo = 1
        self.imgProgress.image = UIImage.init(named: "ic_step1")
        self.imgProgressHeightConstraint.constant = 35
        
        self.containerView.backgroundColor = .white
        
        self.viewProductStep1.frame.size.height = self.containerView.frame.size.height
        
        self.containerView.subviews.forEach({ $0.removeFromSuperview() })
        self.containerView.addSubview(self.viewProductStep1)
    }
    
    func showProductStep2() {
        self.lblNavTitle.text = "Product detail"
        
        self.stepNo = 2
        self.imgProgress.image = UIImage.init(named: "ic_step2")
        
        self.containerView.subviews.forEach({ $0.removeFromSuperview() })
        self.containerView.addSubview(self.viewProductStep2)
        
        if self.txtProductName.text != "" {
            self.txtProductName.setUpImage(imageName: "ic_true", on: .right)
            self.txtProductName.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtProductName.setUpImage(imageName: "", on: .right)
            self.txtProductName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtProductCategory.text != "" {
            self.imgProductCategoryDropdown.image = self.imgProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
            self.imgProductCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
            self.txtProductCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.imgProductCategoryDropdown.image = self.imgProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
            self.imgProductCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
            self.txtProductCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtSubProductCategory.text != "" {
            self.imgSubProductCategoryDropdown.image = self.imgSubProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
            self.imgSubProductCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
            self.txtSubProductCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.imgSubProductCategoryDropdown.image = self.imgSubProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
            self.imgSubProductCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
            self.txtSubProductCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtProductQty.text != "" {
            self.txtProductQty.setUpImage(imageName: "ic_true", on: .right)
            self.txtProductQty.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtProductQty.setUpImage(imageName: "", on: .right)
            self.txtProductQty.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
    }
    
    func showProductStep3() {
        self.lblNavTitle.text = "Product detail"
        
        self.stepNo = 3
        self.imgProgress.image = UIImage.init(named: "ic_step3")
        
        self.containerView.subviews.forEach({ $0.removeFromSuperview() })
        self.containerView.addSubview(self.viewProductStep3)
        
        if self.txtProductDescription.text != "" {
            self.txtProductDescription.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtProductDescription.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtProductLivePrice.text != "" {
            self.txtProductLivePrice.setUpImage(imageName: "ic_true", on: .right)
            self.txtProductLivePrice.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtProductLivePrice.setUpImage(imageName: "", on: .right)
            self.txtProductLivePrice.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtProductOnlinePrice.text != "" {
            self.txtProductOnlinePrice.setUpImage(imageName: "ic_true", on: .right)
            self.txtProductOnlinePrice.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtProductOnlinePrice.setUpImage(imageName: "", on: .right)
            self.txtProductOnlinePrice.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShopInfoClick(_ sender: UIButton) {
        if self.isSelectShop == false {
            self.isSelectShop = true
            
            self.containerView.backgroundColor = .white
            
            self.btnShopInfo.backgroundColor = UIColor.init(hex: 0xD4D4D4)
            self.btnShopInfo.setTitleColor(UIColor.init(hex: 0x333333), for: [])
            
            self.btnProduct.backgroundColor = UIColor.clear
            self.btnProduct.setTitleColor(UIColor.init(hex: 0x9F9F9F), for: [])
            
            self.lblNavTitle.text = "Upload logo"
            self.stepNo = 1
            self.imgProgress.image = UIImage.init(named: "ic_step1")
            self.imgProgressHeightConstraint.constant = 35
            
            self.viewShopStep1.frame.size.height = self.containerView.frame.size.height
            
            self.containerView.subviews.forEach({ $0.removeFromSuperview() })
            self.containerView.addSubview(self.viewShopStep1)
            
            self.removeSetData()
        }
    }
    
    @IBAction func btnProductClick(_ sender: UIButton) {
        if self.objShopDetail.completeStatus == true {
            if self.isSelectShop == true {
                self.isSelectShop = false
                            
                self.containerView.backgroundColor = .clear
                
                self.btnProduct.backgroundColor = UIColor.init(hex: 0xD4D4D4)
                self.btnProduct.setTitleColor(UIColor.init(hex: 0x333333), for: [])
                
                self.btnShopInfo.backgroundColor = UIColor.clear
                self.btnShopInfo.setTitleColor(UIColor.init(hex: 0x9F9F9F), for: [])
                
                self.lblNavTitle.text = "Product"
                self.imgProgressHeightConstraint.constant = 0
                
                self.viewProductList.frame.size.height = self.containerView.frame.size.height

                self.containerView.subviews.forEach({ $0.removeFromSuperview() })
                self.containerView.addSubview(self.viewProductList)
                
                GlobalData.shared.reloadTableView(tableView: self.tblView)
            }
        } else {
            GlobalData.shared.showDarkStyleToastMesage(message: "Complete required shop information first")
        }
    }
    
    @IBAction func btnUploadShopStep1Click(_ sender: UIButton) {
        if self.imgShopLogo.image == nil || self.imgShopLogo.image == #imageLiteral(resourceName: "ic_upload_logo") {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop logo is required")
        } else {
            self.lblNavTitle.text = "Shop detail"
            
            self.stepNo = 2
            self.imgProgress.image = UIImage.init(named: "ic_step2")
            
            self.containerView.subviews.forEach({ $0.removeFromSuperview() })
            self.containerView.addSubview(self.viewShopStep2)
        }
    }
    
    @IBAction func btnCancelShopStep1Click(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextShopStep2Click(_ sender: UIButton) {
        self.view.endEditing(true)
        
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
        else if self.txtShopName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop name is required")
        }
        else {
            self.lblNavTitle.text = "Shop detail"
            
            self.stepNo = 3
            self.imgProgress.image = UIImage.init(named: "ic_step3")
            
            self.containerView.subviews.forEach({ $0.removeFromSuperview() })
            self.containerView.addSubview(self.viewShopStep3)
        }
    }
    
    @IBAction func btnShopCategoryClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.shopCategoryDropDown.show()
    }
    
    @IBAction func btnShopAddressClick(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) |
            GMSPlaceField.addressComponents.rawValue |
            GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        //        filter.type = .geocode
        //        filter.type = .city
        //        filter.country = "my"
        autocompleteController.autocompleteFilter = filter
        
        autocompleteController.modalPresentationStyle = .fullScreen
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadShopStep3Click(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtShopCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop category is required")
        } else if self.txtShopDescription.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop description is required")
        } else if self.txtShopAddress.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Shop address is required")
        } else if self.txtShopZipcode.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Zip code is required")
        } else {
            self.btnUploadShopStep3.isUserInteractionEnabled = false
            self.callUpdateShopInfoAPI()
        }
    }
    
    //PRODUCT
    @IBAction func btnAddProductClick(_ sender: UIButton) {
        self.removeSetData()
        
        self.isEditProduct = false
        self.showProductStep1()
    }
    
    @IBAction func btnUploadProductStep1Click(_ sender: UIButton) {
        if self.arrProductImages.count == 0 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Please add atleast one product image")
        } else {
            if self.isEditProduct == true {
                let objProductCategory = self.arrProductCategory.filter{ $0._id == self.objProductToEdit.category}.first
                
                self.txtProductName.text = self.objProductToEdit.name
                self.txtProductCategory.text = objProductCategory?.name
                self.selectedProductCategory = objProductCategory?._id ?? ""
                self.txtProductQty.text = "\(self.objProductToEdit.qty)"
                self.productLiveDelivery = self.objProductToEdit.live_delvery
                self.productOnlineDelivery = self.objProductToEdit.online_delvery
                
                if self.productLiveDelivery == false {
                    self.switchLiveDelivery.curState = .L
                    self.switchLiveDelivery.circleColor = .white
                }
                else {
                    self.switchLiveDelivery.curState = .R
                    self.switchLiveDelivery.circleColor = .white
                }
                
                if self.productOnlineDelivery == false {
                    self.switchOnlineDelivery.curState = .L
                    self.switchOnlineDelivery.circleColor = .white
                }
                else {
                    self.switchOnlineDelivery.curState = .R
                    self.switchOnlineDelivery.circleColor = .white
                }
                
                self.callSubProductCategoryAPI()
            }
            self.showProductStep2()
        }
    }
    
    @IBAction func btnCancelProductStep1Click(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProductCategoryClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.productCategoryDropDown.show()
    }
    
    @IBAction func btnSubProductCategoryClick(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.txtProductCategory.text == "" {
            GlobalData.shared.showDarkStyleToastMesage(message: "Select product category first")
        } else {
            self.subProductCategoryDropDown.show()
        }
    }
    
    @IBAction func btnNextProductStep2Click(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtProductName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Product name is required")
        }
        else if self.txtProductCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Product category is required")
        }
        else if self.txtSubProductCategory.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Subproduct category is required")
        }
        else if self.txtProductQty.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Product quantity is required")
        }
        else if self.productLiveDelivery == false && self.productOnlineDelivery == false {
            GlobalData.shared.showDarkStyleToastMesage(message: "Enable atleast one delivery option")
        }
        else {
            if self.isEditProduct == true {
                self.txtProductDescription.text = self.objProductToEdit.productDescription
                self.txtProductLivePrice.text = "\(self.objProductToEdit.live_price)"
                self.txtProductOnlinePrice.text = "\(self.objProductToEdit.online_price)"
                self.colorJsonString = self.objProductToEdit.colors
                self.colorJsonString = self.colorJsonString.replacingOccurrences(of: "&#x5C;", with: "")
                
                //DECODE COLOR DATA
                do {
                    let decodeData = self.colorJsonString.data(using: .utf8)!
                    self.arrProductColor = try JSONDecoder().decode([ColorDataObject].self, from: decodeData)
                } catch {
                    debugPrint(error)
                }
                
                self.clViewColor.reloadData()
            }
            self.showProductStep3()
        }
    }
    
    @IBAction func btnUploadProductStep3Click(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtProductDescription.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Product description is required")
        } else if self.txtProductLivePrice.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Live price is required")
        } else if self.txtProductOnlinePrice.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Online price is required")
        } else if self.txtProductDeliveryType.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Product delivery type is required")
        } else {
            self.btnUploadProductStep3.isUserInteractionEnabled = false
            if self.isEditProduct == true {
                self.callUpdateProductAPI()
            } else {
                self.callAddProductAPI()
            }
        }
    }
    
    @IBAction func btnClosePopupClick(_ sender: UIButton) {
        self.viewPopupColorPicker.isHidden = true
    }
    
    @IBAction func btnAddPopupClick(_ sender: UIButton) {
        if self.txtColorName.isEmpty() == 1 {
            GlobalData.shared.showDarkStyleToastMesage(message: "Color name is required")
        } else {
            self.arrProductColor.append(ColorDataObject(hexcode: self.colorHexCode, color_name: self.txtColorName.text ?? ""))
            self.clViewColor.reloadData()
            self.viewPopupColorPicker.isHidden = true
            self.txtColorName.text = ""
            
            //ENCODE COLOR DATA
            do {
                let jsonData = try JSONEncoder().encode(self.arrProductColor)
                self.colorJsonString = String(data: jsonData, encoding: .utf8)!

//                let jsonData1 = self.colorJsonString.data(using: .utf8)!
//                let decodedSentences = try JSONDecoder().decode([ColorDataObject].self, from: jsonData1)
//                debugPrint(decodedSentences)
            } catch {
                debugPrint(error)
            }
        }
    }
}

//MARK: - UISwtch Delegate
extension AddShopInfoVC: LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        
        if sender == self.switchLiveDelivery {
            switch sender.curState {
            case .L:
                debugPrint("OFF")
                self.productLiveDelivery = false
                self.switchLiveDelivery.circleColor = .white
            case .R:
                debugPrint("ON")
                self.productLiveDelivery = true
                self.switchLiveDelivery.circleColor = .white
            }
        } else {
            switch sender.curState {
            case .L:
                debugPrint("OFF")
                self.productOnlineDelivery = false
                self.switchOnlineDelivery.circleColor = .white
            case .R:
                debugPrint("ON")
                self.productOnlineDelivery = true
                self.switchOnlineDelivery.circleColor = .white
            }
        }
    }
}

//MARK: - GOOGLE AUTOCOMPLETE DELEGATE METHOD -

extension AddShopInfoVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        debugPrint(place.coordinate)
        debugPrint(place.name ?? "")
        debugPrint(place.plusCode ?? "")
        debugPrint(place.placeID ?? "")
        
        let placeName = place.name ?? ""
        let placeAddress = place.formattedAddress ?? ""
        
        if placeAddress.contains(placeName) {
            self.txtShopAddress.text = place.formattedAddress
        } else {
            self.txtShopAddress.text = (place.name ?? "") + ", " + (place.formattedAddress ?? "")
        }
        debugPrint(self.txtShopAddress.text ?? "")
        
        self.strLattitude = String(place.coordinate.latitude) //String(format: "%.7f", place.coordinate.latitude)
        self.strLongitude = String(place.coordinate.longitude) //String(format: "%.7f", place.coordinate.longitude)
        
        if let addressComponents = place.addressComponents {
            for component in addressComponents {
                if component.types.contains("postal_code") {
                    self.txtShopZipcode.text = "\(component.shortName ?? "")"
                    break
                } else {
                    self.txtShopZipcode.text = ""
                }
            }
        }
        
        if self.txtShopAddress.text != "" {
            self.txtShopAddress.setUpImage(imageName: "ic_true", on: .right)
            self.txtShopAddress.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtShopAddress.setUpImage(imageName: "", on: .right)
            self.txtShopAddress.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        if self.txtShopZipcode.text != "" {
            self.txtShopZipcode.setUpImage(imageName: "ic_true", on: .right)
            self.txtShopZipcode.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
        } else {
            self.txtShopZipcode.setUpImage(imageName: "", on: .right)
            self.txtShopZipcode.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - SHOW MEDIA PICKER OPTIONS -

extension AddShopInfoVC {
    
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
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.imgShopLogo.frame.origin.y - 60, width: 0, height: 0) //sender.bounds
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

extension AddShopInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if self.isSelectShopLogo == true {
            let image = info[.originalImage] as! UIImage
//            let image = info[.editedImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.5)!
            self.imgShopLogo.image = image
            self.imgShopLogo.contentMode = .scaleAspectFill
            
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
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_shop_image.jpg"
            let document = Document(
                uploadParameterKey: "image",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.shopLogoDocument = document
            
            picker.dismiss(animated: true, completion: nil)
        }
        else {
            let image = info[.originalImage] as! UIImage
//            let image = info[.editedImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.5)!
            self.arrProductImages.append(image)
            
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
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_product.jpg"
            let document = Document(
                uploadParameterKey: "productImage",
                data: data,
                name: name ?? filename,
                fileName: filename,
                mimeType: "image/jpeg"
            )
            self.productImageDocument.append(document)
            
            picker.dismiss(animated: true, completion: nil)
            
            GlobalData.shared.reloadCollectionView(collectionView: self.clViewProduct)
        }
    }
}

//MARK: - UITEXTFIELD DELEGATE METHOD -

extension AddShopInfoVC: UITextFieldDelegate {
    
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtName {
            if self.txtName.text != "" {
                self.txtName.setUpImage(imageName: "ic_true", on: .right)
                self.txtName.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtName.setUpImage(imageName: "", on: .right)
                self.txtName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtEmail {
            if self.txtEmail.text != "" {
                self.txtEmail.setUpImage(imageName: "ic_true", on: .right)
                self.txtEmail.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtEmail.setUpImage(imageName: "", on: .right)
                self.txtEmail.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtPassword {
            if self.txtPassword.text != "" {
                self.txtPassword.setUpImage(imageName: "ic_true", on: .right)
                self.txtPassword.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtPassword.setUpImage(imageName: "", on: .right)
                self.txtPassword.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtShopName {
            if self.txtShopName.text != "" {
                self.txtShopName.setUpImage(imageName: "ic_true", on: .right)
                self.txtShopName.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtShopName.setUpImage(imageName: "", on: .right)
                self.txtShopName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtShopZipcode {
            if self.txtShopZipcode.text != "" {
                self.txtShopZipcode.setUpImage(imageName: "ic_true", on: .right)
                self.txtShopZipcode.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtShopZipcode.setUpImage(imageName: "", on: .right)
                self.txtShopZipcode.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtProductName {
            if self.txtProductName.text != "" {
                self.txtProductName.setUpImage(imageName: "ic_true", on: .right)
                self.txtProductName.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtProductName.setUpImage(imageName: "", on: .right)
                self.txtProductName.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtProductQty {
            if self.txtProductQty.text != "" {
                self.txtProductQty.setUpImage(imageName: "ic_true", on: .right)
                self.txtProductQty.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtProductQty.setUpImage(imageName: "", on: .right)
                self.txtProductQty.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtProductLivePrice {
            if self.txtProductLivePrice.text != "" {
                self.txtProductLivePrice.setUpImage(imageName: "ic_true", on: .right)
                self.txtProductLivePrice.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtProductLivePrice.setUpImage(imageName: "", on: .right)
                self.txtProductLivePrice.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtProductOnlinePrice {
            if self.txtProductOnlinePrice.text != "" {
                self.txtProductOnlinePrice.setUpImage(imageName: "ic_true", on: .right)
                self.txtProductOnlinePrice.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtProductOnlinePrice.setUpImage(imageName: "", on: .right)
                self.txtProductOnlinePrice.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textField == self.txtProductDeliveryType {
            if self.txtProductDeliveryType.text != "" {
                self.txtProductDeliveryType.setUpImage(imageName: "ic_true", on: .right)
                self.txtProductDeliveryType.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtProductDeliveryType.setUpImage(imageName: "", on: .right)
                self.txtProductDeliveryType.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        }
    }
}

//MARK: - UITEXTVIEW DELEGATE METHOD -

extension AddShopInfoVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.tintColor = UIColor.init(hex: 0x333333)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.txtShopDescription {
            if self.txtShopDescription.text != "" {
                self.txtShopDescription.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtShopDescription.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        } else if textView == self.txtProductDescription {
            if self.txtProductDescription.text != "" {
                self.txtProductDescription.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
            } else {
                self.txtProductDescription.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
            }
        }
    }
}

//MARK: - UITABLEVIEW DATASOURCE & DELEGATE -

extension AddShopInfoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrProductList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let objProductDetail = self.arrProductList[indexPath.section]
        let objImages = objProductDetail.arrProductImages
        
        if objImages.count > 0 {
            cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProduct.sd_setImage(with: URL(string: objImages[0].image), placeholderImage: UIImage.init(named: "ic_no_image"))
        } else {
            cell.imgProduct.image = UIImage.init(named: "ic_no_image")
        }
        
        cell.lblProductName.text = objProductDetail.name
        cell.lblProductDescription.text = objProductDetail.productDescription
        cell.lblProductPrice.text = "$\(objProductDetail.live_price)"
        cell.ratingView.rating = 3.0
        cell.ratingView.text = "(4.1)"
        
        cell.btnUpdate.tag = indexPath.section
        cell.btnUpdate.addTarget(self, action: #selector(btnUpdateProductClick), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.section
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteProductClick), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    //CELL BUTTON ACTION
    
    @objc func btnUpdateProductClick(_ sender: UIButton) {
        self.objProductToEdit = self.arrProductList[sender.tag]
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        for productImage in self.objProductToEdit.arrProductImages {
            let imageUrl = URL(string: productImage.image)!
            guard let image = try? UIImage(withContentsOfUrl: imageUrl) else { return }
            
            self.arrProductImages.append(image)
            
            let data = image.jpegData(compressionQuality: 0.5)!
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000.0))_product.jpg"
            let document = Document(
                uploadParameterKey: "productImage",
                data: data,
                name: filename, //productImage.name,
                fileName: filename, //productImage.name,
                mimeType: "image/jpeg"
            )
            self.productImageDocument.append(document)
        }
        
        GlobalData.shared.hideProgress()
        
        self.isEditProduct = true
        self.showProductStep1()
        
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewProduct)
    }
    
    @objc func btnDeleteProductClick(_ sender: UIButton) {
        let objProductDetail = self.arrProductList[sender.tag]
        
        GlobalData.shared.displayConfirmationAlert(self, title: "Delete Product", message: "Would you like to delete this product?", btnTitle1: "Cancel", btnTitle2: "Delete", actionBlock: { (isConfirmed) in
            if isConfirmed {
                self.callDeleteProductAPI(SelectedProductID: objProductDetail._id)
            }
        })
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -

extension AddShopInfoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clViewProduct {
            return self.arrProductImages.count + 1
        } else {
            return self.arrProductColor.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.clViewProduct {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath as IndexPath) as! ProductImageCell
            
            if indexPath.item == 0 {
                cell.viewAdd.isHidden = false
                cell.viewContent.isHidden = true
                
                cell.btnAdd.tag = indexPath.item
                cell.btnAdd.addTarget(self, action: #selector(btnAddTapped), for: .touchUpInside)
            } else {
                cell.viewAdd.isHidden = true
                cell.viewContent.isHidden = false
                
                cell.imgView.image = self.arrProductImages[indexPath.item - 1]
                
                cell.btnDelete.tag = indexPath.item - 1
                cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped), for: .touchUpInside)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductColorCell", for: indexPath as IndexPath) as! ProductColorCell
            
            if indexPath.item == 0 {
                cell.imgAdd.isHidden = false
                cell.imgView.isHidden = true
                
                let objGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageAddClick(_:)))
                cell.imgAdd.addGestureRecognizer(objGesture)
                cell.imgAdd.isUserInteractionEnabled = true
            } else {
                cell.imgAdd.isHidden = true
                cell.imgView.isHidden = false
                
                let hexCode = self.arrProductColor[indexPath.item - 1].hexcode
                cell.imgView.backgroundColor = GlobalData.shared.hexStringToUIColor(hex: hexCode)
                
                cell.imgView.layer.cornerRadius = cell.imgView.layer.frame.size.height / 2
                cell.imgView.clipsToBounds = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.clViewProduct {
            let noOfCellsInRow = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: size)
        } else {
            let size = self.clViewColor.frame.size.height
            return CGSize(width: size, height: size)
        }
    }
    
    //CELL ACTION
    
    @objc func btnAddTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.isSelectShopLogo = false
        self.showMediaPickerOptions()
    }
    
    @objc func btnDeleteTapped(_ sender: UIButton) {
        self.arrProductImages.remove(at: sender.tag)
        self.productImageDocument.remove(at: sender.tag)
        
        GlobalData.shared.reloadCollectionView(collectionView: self.clViewProduct)
    }
    
    @objc func imageAddClick(_ sender:UITapGestureRecognizer) -> Void {
        self.viewPopupColorPicker.isHidden = false
    }
}

//MARK: - API CALL -

extension AddShopInfoVC {
    
    //PRODUCT CATEGORY LIST
    func callProductCategoryAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        AFWrapper.shared.requestGETURL(Constants.URLS.GET_PRODUCT_CATEGORY) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            for i in 0..<payloadData.count {
                                let objProduct = ProductCategoryObject.init(payloadData[i])
                                strongSelf.arrProductCategory.append(objProduct)
                            }
                            strongSelf.setupProductCategoryDropDown()
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
        } failure: { (error) in
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //SUB PRODUCT CATEGORY LIST
    func callSubProductCategoryAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.GET_SUBPRODUCT_CATEGORY + "/" + "\(self.selectedProductCategory)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestGETURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        if let payloadData = response["data"] as? [Dictionary<String, Any>] {
                            strongSelf.arrSubProductCategory.removeAll()
                            for i in 0..<payloadData.count {
                                let objSubProduct = SubProductCategoryObject.init(payloadData[i])
                                strongSelf.arrSubProductCategory.append(objSubProduct)
                            }
                            strongSelf.setupSubProductCategoryDropDown()
                            
                            if strongSelf.isEditProduct == true {
                                let objSubProductCategory = strongSelf.arrSubProductCategory.filter{ $0._id == strongSelf.objProductToEdit.subcategory}.first
                                
                                strongSelf.txtSubProductCategory.text = objSubProductCategory?.name
                                strongSelf.selectedSubProductCategory = objSubProductCategory?._id ?? ""
                                
                                if strongSelf.txtSubProductCategory.text != "" {
                                    strongSelf.imgSubProductCategoryDropdown.image = strongSelf.imgSubProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                                    strongSelf.imgSubProductCategoryDropdown.tintColor = Constants.Color.THEME_YELLOW
                                    strongSelf.txtSubProductCategory.layer.borderColor = Constants.Color.THEME_YELLOW.cgColor
                                } else {
                                    strongSelf.imgSubProductCategoryDropdown.image = strongSelf.imgSubProductCategoryDropdown.image?.withRenderingMode(.alwaysTemplate)
                                    strongSelf.imgSubProductCategoryDropdown.tintColor = UIColor.init(hex: 0x333333)
                                    strongSelf.txtSubProductCategory.layer.borderColor = UIColor.init(hex: 0x707070).cgColor
                                }
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
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
    
    //UPLOAD SHOP INFORMATION API
    func callUpdateShopInfoAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["shopName"] = self.txtShopName.text ?? ""
        params["category"] = self.selectedShopCategory
        params["description"] = self.txtShopDescription.text ?? ""
        params["address"] = self.txtShopAddress.text ?? ""
        params["zipCode"] = self.txtShopZipcode.text ?? ""
        params["latitude"] = self.strLattitude
        params["longitude"] = self.strLongitude
        
        var selectedDocs: [Document] = []
        if let selectedDoc = self.shopLogoDocument {
            selectedDocs = [selectedDoc]
        }
        
        let strURL = Constants.URLS.GET_SHOP + "/" + "\(self.strShopID)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.postWithUploadMultipleFiles(selectedDocs, strURL: strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        
                        strongSelf.btnUploadShopStep3.isUserInteractionEnabled = true
                        
                        NotificationCenter.default.post(name: Notification.Name(kUpdateShopInformation), object: nil)
                        NotificationCenter.default.post(name: Notification.Name(kUpdateShopList), object: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnUploadShopStep3.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnUploadShopStep3.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnUploadShopStep3.isUserInteractionEnabled = true
        }
    }
    
    //ADD PRODUCT API
    func callAddProductAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["name"] = self.txtProductName.text ?? ""
        params["category"] = self.selectedProductCategory
        params["subcategory"] = self.selectedSubProductCategory
        params["qty"] = self.txtProductQty.text ?? ""
        params["live_delvery"] = self.productLiveDelivery
        params["online_delvery"] = self.productOnlineDelivery
        params["description"] = self.txtProductDescription.text ?? ""
        params["live_price"] = self.txtProductLivePrice.text ?? ""
        params["online_price"] = self.txtProductOnlinePrice.text ?? ""
        params["colors"] = self.colorJsonString ?? ""
        params["shop"] = self.strShopID
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.postWithUploadMultipleFiles(self.productImageDocument, strURL: Constants.URLS.ADD_PRODUCT, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))

                            let objProduct = ProductObject.init(payload)
                            strongSelf.arrProductList.insert(objProduct, at: 0)
                            
                            strongSelf.btnUploadProductStep3.isUserInteractionEnabled = true
                            //********//
                            strongSelf.containerView.backgroundColor = .clear
                            
                            strongSelf.btnProduct.backgroundColor = UIColor.init(hex: 0xD4D4D4)
                            strongSelf.btnProduct.setTitleColor(UIColor.init(hex: 0x333333), for: [])
                            
                            strongSelf.btnShopInfo.backgroundColor = UIColor.clear
                            strongSelf.btnShopInfo.setTitleColor(UIColor.init(hex: 0x9F9F9F), for: [])
                            
                            strongSelf.lblNavTitle.text = "Product"
                            strongSelf.imgProgressHeightConstraint.constant = 0
                            
                            strongSelf.viewProductList.frame.size.height = strongSelf.containerView.frame.size.height

                            strongSelf.containerView.subviews.forEach({ $0.removeFromSuperview() })
                            strongSelf.containerView.addSubview(strongSelf.viewProductList)
                            
                            if strongSelf.arrProductList.count > 0 {
                                strongSelf.lblNoRecord.isHidden = true
                            } else {
                                strongSelf.lblNoRecord.isHidden = false
                            }
                            strongSelf.tblView.isHidden = false
                            
                            GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                            
                            strongSelf.removeSetData()
                            //********//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                strongSelf.navigationController?.popViewController(animated: true)
//                            }
                            
                            NotificationCenter.default.post(name: Notification.Name(kUpdateProductList), object: nil)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnUploadProductStep3.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnUploadProductStep3.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnUploadProductStep3.isUserInteractionEnabled = true
        }
    }
    
    //UPDATE PRODUCT API
    func callUpdateProductAPI() {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        var params: [String:Any] = [:]
        params["name"] = self.txtProductName.text ?? ""
        params["category"] = self.selectedProductCategory
        params["subcategory"] = self.selectedSubProductCategory
        params["qty"] = self.txtProductQty.text ?? ""
        params["live_delvery"] = self.productLiveDelivery
        params["online_delvery"] = self.productOnlineDelivery
        params["description"] = self.txtProductDescription.text ?? ""
        params["live_price"] = self.txtProductLivePrice.text ?? ""
        params["online_price"] = self.txtProductOnlinePrice.text ?? ""
        params["colors"] = self.colorJsonString ?? ""
        params["shop"] = self.strShopID
        
        let strURL = Constants.URLS.UPDATE_PRODUCT + "/" + "\(self.objProductToEdit._id)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.postWithUploadMultipleFiles(self.productImageDocument, strURL: strURL, params: params, headers: nil, success: { [weak self] (JSONResponse) -> Void in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let payload = response["data"] as? Dictionary<String, Any> {
                            let objProduct = ProductObject.init(payload)
                            
                            GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                            
                            if let row = strongSelf.arrProductList.firstIndex(where: {$0._id == strongSelf.objProductToEdit._id}) {
                                strongSelf.arrProductList[row] = objProduct
                            }
                            
                            strongSelf.btnUploadProductStep3.isUserInteractionEnabled = true
                            //********//
                            strongSelf.containerView.backgroundColor = .clear
                            
                            strongSelf.btnProduct.backgroundColor = UIColor.init(hex: 0xD4D4D4)
                            strongSelf.btnProduct.setTitleColor(UIColor.init(hex: 0x333333), for: [])
                            
                            strongSelf.btnShopInfo.backgroundColor = UIColor.clear
                            strongSelf.btnShopInfo.setTitleColor(UIColor.init(hex: 0x9F9F9F), for: [])
                            
                            strongSelf.lblNavTitle.text = "Product"
                            strongSelf.imgProgressHeightConstraint.constant = 0
                            
                            strongSelf.viewProductList.frame.size.height = strongSelf.containerView.frame.size.height

                            strongSelf.containerView.subviews.forEach({ $0.removeFromSuperview() })
                            strongSelf.containerView.addSubview(strongSelf.viewProductList)
                            
                            GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                            
                            strongSelf.removeSetData()
                            //********//
                            
                            NotificationCenter.default.post(name: Notification.Name(kUpdateProductList), object: nil)
                        }
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        strongSelf.btnUploadProductStep3.isUserInteractionEnabled = true
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        strongSelf.btnUploadProductStep3.isUserInteractionEnabled = true
                    }
                }
            }
        }) { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
            self.btnUploadProductStep3.isUserInteractionEnabled = true
        }
    }
    
    //DELETE PRODUCT API
    func callDeleteProductAPI(SelectedProductID selectedProductID: String) {
        if GlobalData.shared.checkInternet() == false {
            GlobalData.shared.displayAlertMessage(Title: kAlert, Message: kInternetUnavailable)
            return
        }
        
        let strURL = Constants.URLS.DELETE_PRODUCT + "/" + "\(selectedProductID)"
        
        GlobalData.shared.showProgressWithTitle(title: kPleaseWait)
        
        AFWrapper.shared.requestDELETEURL(strURL) { [weak self] (JSONResponse) in
            guard let strongSelf = self else { return }
            
            GlobalData.shared.hideProgress()
            
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["status"] as? Int ?? 0 == successCode {
                        if let row = strongSelf.arrProductList.firstIndex(where: {$0._id == selectedProductID}) {
                            strongSelf.arrProductList.remove(at: row)
                        }
                        
                        if strongSelf.arrProductList.count > 0 {
                            strongSelf.lblNoRecord.isHidden = true
                        } else {
                            strongSelf.lblNoRecord.isHidden = false
                        }
                        strongSelf.tblView.isHidden = false
                        
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                        GlobalData.shared.reloadTableView(tableView: strongSelf.tblView)
                        
                        NotificationCenter.default.post(name: Notification.Name(kUpdateProductList), object: nil)
                    }
                    else if response["status"] as? Int ?? 0 == invalidTokenCode {
                        GlobalData.shared.displayInvalidTokenAlert(Title: kAlert, Message: (response["message"] as? String ?? ""))
                    }
                    else {
                        GlobalData.shared.showDarkStyleToastMesage(message: (response["message"] as? String ?? ""))
                    }
                }
            }
        } failure: { (error) in
            GlobalData.shared.hideProgress()
            GlobalData.shared.showDarkStyleToastMesage(message: kNetworkError)
        }
    }
}
